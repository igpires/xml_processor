class DocumentsController < ApplicationController
  before_action :new_document, only: [:new]
  before_action :set_report_params, only: [:report]
  before_action :filter_params, only: [:index]

  def index
    @q = Document.ransack(params[:q], auth_object: current_user)
    @documents = @q.result(distinct: true).where(user: current_user).order(created_at: :desc)
  end

  def new
  end

  def create
    service = DocumentBusiness::Create.new(document_params.merge(user: current_user))
    service.call

    if service.error
      redirect_to new_document_path, alert: "Erro ao criar documento: #{service.error}"
    else
      redirect_to documents_path, notice: service.message
    end

  rescue ActionController::ParameterMissing => e
    redirect_to new_document_path, alert: "Erro ao criar documento. #{e.message}"
  end

  def report
  end

  private

  def filter_params
    if params[:q].present?
      params[:q].delete_if { |key, value| value.blank? || value == "0" }
    end
  end

  def set_report_params
    @document = Document.includes(:parties, :financial_summary, :products).find(params[:document_id])
    @parties = @document.parties
    @financial_summary = @document.financial_summary
    @products = @document.products
  end

  def new_document
    @document = Document.new
  end

  def document_params
    params.require(:document).permit(:file)
  end
end
