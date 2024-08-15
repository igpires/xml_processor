class CreateParties < ActiveRecord::Migration[7.0]
  def change
    create_table :parties do |t|
      t.string :cnpj
      t.string :legal_name
      t.string :trade_name
      t.jsonb :details
      t.integer :role
      t.string :document_id

      t.timestamps
    end
  end
end
