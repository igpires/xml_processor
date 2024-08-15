class CreateTaxes < ActiveRecord::Migration[7.0]
  def change
    create_table :taxes do |t|
      t.decimal :icms_value, precision: 15, scale: 2
      t.decimal :ipi_value, precision: 15, scale: 2
      t.decimal :pis_value, precision: 15, scale: 2
      t.string :cofins_total, precision: 15, scale: 2
      t.integer :product_id

      t.timestamps
    end
  end
end
