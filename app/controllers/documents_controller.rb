class DocumentsController < ApplicationController
  before_action :new_document, only: [:new]
  before_action :set_documents, only: [:index]
  before_action :set_report_params, only: [:report]



  def index
  end

  def new
  end

  def create
    @document = current_user.documents.build(document_params)

    if @document.save
      redirect_to documents_path, notice: "Documento criado com sucesso."
    else
      render :new
    end
  end

  def report
  end

  private

  def set_report_params
    @document = Document.includes(:parties, :financial_summary, :products).find(params[:document_id])
    @parties = @document.parties
    @financial_summary = @document.financial_summary
    @products = @document.products
  end


  def new_document
    @document = Document.new
  end

  def set_documents
    @documents = current_user.documents.order(created_at: :desc)
  end

  def document_params
    params.require(:document).permit(:xml_file)
  end
end
