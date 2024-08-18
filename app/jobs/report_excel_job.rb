class ReportExcelJob < ApplicationJob
  queue_as :default

  def perform(document)
    @document = document

    begin
      process_xlsx
    rescue StandardError => e
      Rails.logger.error "Failed processing XML: #{e.message}"
    end
  end

  private


  def process_xlsx
    set_details

    temp_file = ReportBusiness::ExportXlsx.new(@details).call

    @document.excel_report.attach(
      io: File.open(temp_file.path),
      filename: 'report.xlsx',
      content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )

    temp_file.close
  end

  def set_details
    @details = [
      set_document_details,
      set_parties,
      set_financial_summary,
      set_products
    ]
  end

  def set_document_details
    {
      section_title: 'Documento',
      section_layout: :detailed,
      data: [
        {'ID Interno' => @document.id},
        {'Número de Série' => @document.serie_number},
        {'Número do Documento' => @document.invoice_number},
        {'Data de Emissão' => @document.emission_date.strftime('%d/%m/%Y')}
      ]
    }
  end

  def set_parties
    {
      section_title: 'Envolvidos',
      section_layout: :summary,
      data: [
        {
          'Tipo' => 'Emissor',
          'CNPJ' => @document.parties.find_by(role: 'issuer')&.cnpj,
          'Razão Social' => @document.parties.find_by(role: 'issuer')&.legal_name,
          'Nome Fantasia' => @document.parties.find_by(role: 'issuer')&.trade_name
        },
        {
          'Tipo' => 'Destinatário',
          'CNPJ' => @document.parties.find_by(role: 'recipient')&.cnpj,
          'Razão Social' => @document.parties.find_by(role: 'recipient')&.legal_name,
          'Nome Fantasia' => @document.parties.find_by(role: 'recipient')&.trade_name
        }
      ]
    }
  end

  def set_financial_summary
    {
      section_title: 'Resumo Financeiro',
      section_layout: :detailed,
      data: [
        {'Valor dos Produtos' => "R$ #{@document.financial_summary&.product_total}"},
        {'Total de ICMS' => "R$ #{@document.financial_summary&.icms_total}"},
        {'Total de IPI' => "R$ #{@document.financial_summary&.ipi_total}"},
        {'Total de PIS' => "R$ #{@document.financial_summary&.pis_total}"},
        {'Total de COFINS' => "R$ #{@document.financial_summary&.cofins_total}"},
        {'Total de Impostos' => "R$ #{@document.financial_summary&.total_taxes}"}
      ]
    }
  end

  def set_products
    {
      section_title: 'Produtos',
      section_layout: :summary,
      data: @document.products.map do |product|
        {
          'Nome' => product.name,
          'NCM' => product.ncm,
          'CFOP' => product.cfop,
          'Unidade de Medida' => product.commercial_unit,
          'Quantidade Vendida' => product.quantity_sold,
          'Preço Unitário' => "R$ #{product.unit_price}",
          'ICMS' => "R$ #{product.tax&.icms_value}",
          'IPI' => "R$ #{product.tax&.ipi_value}",
          'PIS' => "R$ #{product.tax&.pis_value}",
          'COFINS' => "R$ #{product.tax&.cofins_total}"
        }
      end
    }
  end

end
