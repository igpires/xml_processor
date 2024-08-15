class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string  :name                # xProd: Nome do produto
      t.string  :ncm                 # NCM: Código NCM
      t.string  :cfop                # CFOP: Código CFOP
      t.string  :commercial_unit     # uCom: Unidade comercializada
      t.decimal :quantity_sold, precision: 15, scale: 4  # qCom: Quantidade comercializada
      t.decimal :unit_price, precision: 15, scale: 10    # vUnCom: Valor unitário
      t.integer :document_id

      t.timestamps
    end
  end
end
