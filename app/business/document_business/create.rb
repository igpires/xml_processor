module DocumentBusiness
  class Create
    attr_reader :message, :error

    def initialize(document_params)
      @document_params = document_params
    end

    def call
      run
    end

    private

    def run
      content_type = @document_params[:file].content_type.downcase.split("/")[1]

      case content_type
      when "xml"
        create_document
      when "zip"
        create_documents_from_zip
      else
        @error = "Invalid file type"
      end
    end

    def create_document
      document = Document.new(xml_file: @document_params[:file], user: @document_params[:user])

      if document.save
        @message = "Documento enviado para processamento."
      else
        @error = "Erro ao criar documento. #{document.errors.full_messages.join(", ")}"
      end
    end

    def create_documents_from_zip
      zip_file = @document_params[:file]
      user = @document_params[:user]

      # Salvar o arquivo ZIP temporariamente
      temp_file_path = save_temp_file(zip_file)

      # Passar o caminho do arquivo temporário para o job
      ProcessZipJob.perform_later(temp_file_path, user)
      @message = "Arquivo ZIP enviado para processamento."
    end

    def save_temp_file(uploaded_file)
      temp_file_path = Rails.root.join('tmp', "upload_#{SecureRandom.uuid}.zip")
      File.open(temp_file_path, 'wb') do |file|
        file.write(uploaded_file.read)
      end
      temp_file_path.to_s
    end

  end
end
