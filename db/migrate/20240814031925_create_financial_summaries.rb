class CreateFinancialSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_summaries do |t|
      t.decimal :product_total, precision: 15, scale: 2  # vProd: Valor total dos produtos
      t.decimal :icms_total, precision: 15, scale: 2     # vICMS: Valor total do ICMS
      t.decimal :ipi_total, precision: 15, scale: 2      # vIPI: Valor total do IPI
      t.decimal :pis_total, precision: 15, scale: 2      # vPIS: Valor total do PIS
      t.decimal :cofins_total, precision: 15, scale: 2   # vCOFINS: Valor total do COFINS
      t.decimal :total_taxes, precision: 15, scale: 2    # vTotTrib: Valor total dos tributos federais
      t.integer :document_id

      t.timestamps
    end
  end
end
