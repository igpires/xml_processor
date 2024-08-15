class Product < ApplicationRecord
  # Associations
  belongs_to :document
  has_one :tax, dependent: :destroy
end
