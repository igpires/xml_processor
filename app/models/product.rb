class Product < ApplicationRecord
  # Associations
  belongs_to :document
  has_one :tax, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["cfop", "commercial_unit", "created_at", "document_id", "id", "name", "ncm", "quantity_sold", "unit_price", "updated_at"]
  end
end
