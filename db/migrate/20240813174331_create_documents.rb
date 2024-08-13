class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :file_name
      t.integer :status
      t.string :error_message
      t.integer :user_id

      t.timestamps
    end
  end
end
