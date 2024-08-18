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
  has_one_attached :excel_report

  # Validations
  validates :xml_file, presence: true
  validate :correct_xml_mime_type

  # Callbacks
  before_create :default_status
  after_create :processing_xml
  after_save :create_excel_report, if: -> { status == "processed" && !excel_report.attached? }

  private

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "emission_date", "error_message", "id", "invoice_number", "serie_number", "status", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products", "parties", "financial_summary"]
  end

  def processing_xml
    ProcessXmlJob.perform_later(self)
  end

  def create_excel_report
    ReportExcelJob.perform_later(self)
  end

  def default_status
    self.status = :pending
  end

  def correct_xml_mime_type
    errors.add(:xml_file, 'deve ser um arquivo XML') unless xml_file.content_type.in?(%w(application/xml text/xml))
  end

end
