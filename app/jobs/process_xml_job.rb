class ProcessXmlJob < ApplicationJob
  queue_as :default

  def perform(document)
    @document = document

    begin
      process_document
    rescue StandardError => e
      @document.update!(status: :failed, error_message: e.message)
      Rails.logger.error "Failed processing XML: #{e.message}"
    end
  end

  private

  def process_document
    @document.update!(status: :processing)
    parsed_xml = read_xml_file

    update_document_infos(parsed_xml)
    create_financial_summary(parsed_xml)
    save_parties(parsed_xml)
    create_products(parsed_xml)

    @document.update!(status: :processed)
    Rails.logger.info "Finished processing XML document ID: #{@document.id}"
  end

  def read_xml_file
    @document.xml_file.open do |file|
      parsed_xml = Nokogiri::XML(file.read)

      parsed_xml
    end
  end


  def update_document_infos(parsed_xml)
    @document.update!(
      serie_number: parsed_xml.xpath('//nfe:serie', nfe_namespace).text,
      invoice_number: parsed_xml.xpath('//nfe:nNF', nfe_namespace).text,
      emission_date: parsed_xml.xpath('//nfe:dhEmi', nfe_namespace).text
    )
  end

  def create_financial_summary(parsed_xml)
    FinancialSummary.create!(
      product_total: parsed_xml.xpath('//nfe:ICMSTot/nfe:vProd', nfe_namespace).text.to_f,
      icms_total: parsed_xml.xpath('//nfe:ICMSTot/nfe:vICMS', nfe_namespace).text.to_f,
      ipi_total: parsed_xml.xpath('//nfe:ICMSTot/nfe:vIPI', nfe_namespace).text.to_f,
      pis_total: parsed_xml.xpath('//nfe:ICMSTot/nfe:vPIS', nfe_namespace).text.to_f,
      cofins_total: parsed_xml.xpath('//nfe:ICMSTot/nfe:vCOFINS', nfe_namespace).text.to_f,
      total_taxes: parsed_xml.xpath('//nfe:ICMSTot/nfe:vTotTrib', nfe_namespace).text.to_f,
      document: @document
    )
  end

  def save_parties(parsed_xml)
    save_party(parsed_xml.xpath('//nfe:emit', nfe_namespace), 'issuer')
    save_party(parsed_xml.xpath('//nfe:dest', nfe_namespace), 'recipient')
  end

  def save_party(party_node, role)
    Party.create!(
      cnpj: party_node.xpath('nfe:CNPJ', nfe_namespace).text,
      legal_name: party_node.xpath('nfe:xNome', nfe_namespace).text,
      trade_name: party_node.xpath('nfe:xFant', nfe_namespace).text,
      role: role,
      document: @document
    )
  end

  def create_products(parsed_xml)
    parsed_xml.xpath('//nfe:det', nfe_namespace).each do |product_node|
      product = Product.create!(
        name: product_node.xpath('nfe:prod/nfe:xProd', nfe_namespace).text,
        ncm: product_node.xpath('nfe:prod/nfe:NCM', nfe_namespace).text,
        cfop: product_node.xpath('nfe:prod/nfe:CFOP', nfe_namespace).text,
        commercial_unit: product_node.xpath('nfe:prod/nfe:uCom', nfe_namespace).text,
        quantity_sold: product_node.xpath('nfe:prod/nfe:qCom', nfe_namespace).text.to_f,
        unit_price: product_node.xpath('nfe:prod/nfe:vUnCom', nfe_namespace).text.to_f,
        document: @document
      )

      create_tax(product, product_node)
    end
  end

  def create_tax(product, product_node)
    Tax.create!(
      icms_value: product_node.xpath('nfe:imposto/nfe:ICMS/nfe:ICMS00/nfe:vICMS', nfe_namespace).text.to_f,
      ipi_value: product_node.xpath('nfe:imposto/nfe:IPI/nfe:IPITrib/nfe:vIPI', nfe_namespace).text.to_f,
      pis_value: product_node.xpath('nfe:imposto/nfe:PIS/nfe:PISNT/nfe:vPIS', nfe_namespace).text.to_f,
      cofins_total: product_node.xpath('nfe:imposto/nfe:COFINS/nfe:COFINSNT/nfe:vCOFINS', nfe_namespace).text.to_f,
      product: product
    )
  end

  def nfe_namespace
    { 'nfe' => 'http://www.portalfiscal.inf.br/nfe' }
  end
end
