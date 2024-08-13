class Document < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum status: { pedding: 0, processing: 1, processed: 2, failed: 3 }

  # ActiveStorage
  has_one_attached :xml_file

  # Validations
  validates :xml_file, presence: true

  # Callbacks
  after_create :set_file_name

  private

  def set_file_name
    xml_file.filename.to_s if xml_file.attached?
  end

end
