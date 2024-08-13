class DocumentsController < ApplicationController
  def index
    @documents = current_user.documents
  end

  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)

    if @document.save
      redirect_to documents_path, notice: "Documento criado com sucesso."
    else
      render :new
    end
  end

  private

  def document_params
    params.require(:document).permit(:xml_file)
  end
end
