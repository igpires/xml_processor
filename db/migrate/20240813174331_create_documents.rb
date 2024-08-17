class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :serie_number
      t.string :invoice_number
      t.date :emission_date
      t.integer :status, default: 0
      t.string :error_message
      t.integer :user_id

      t.timestamps
    end
  end
end
