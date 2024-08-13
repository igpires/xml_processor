class Document < ApplicationRecord
  # Associations
  belongs_to :user

  # Enums
  enum status: { pending: 0, processing: 1, processed: 2, failed: 3 }

  # ActiveStorage
  has_one_attached :xml_file

  # Validations
  validates :xml_file, presence: true
  validate :correct_xml_mime_type

  # Callbacks
  before_create :set_file_name, :default_status

  private

  def set_file_name
    self.file_name = xml_file.filename.to_s if xml_file.attached?
  end

  def default_status
    self.status = :pending
  end

  def correct_xml_mime_type
    errors.add(:xml_file, 'deve ser um arquivo XML') unless xml_file.content_type.in?(%w(application/xml text/xml))
  end

end
