class Document < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :parties, dependent: :destroy
  has_one :financial_summary, dependent: :destroy
  has_many :products, dependent: :destroy

  # Enums
  enum status: { pending: 0, processing: 1, processed: 2, failed: 3 }

  # ActiveStorage
  has_one_attached :xml_file

  # Validations
  validates :xml_file, presence: true
  validate :correct_xml_mime_type

  # Callbacks
  before_create :default_status

  private

  def default_status
    self.status = :pending
  end

  def correct_xml_mime_type
    errors.add(:xml_file, 'deve ser um arquivo XML') unless xml_file.content_type.in?(%w(application/xml text/xml))
  end

end
