class Party < ApplicationRecord
  # Associations
  belongs_to :document

  # Enums
  enum role: { issuer: 0, recipient: 1 }

end
