require 'zip'

class ProcessZipJob < ApplicationJob
  queue_as :default

  def perform(file_path, user)
    begin
      process_zip(file_path, user)
    rescue StandardError => e
      Rails.logger.error "Failed processing ZIP: #{e.message}"
    ensure
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  private

  def process_zip(file_path, user)
    Zip::File.open(file_path) do |zip_file|
      zip_file.each do |entry|
        next unless entry.name.end_with?('.xml')

        create_document_from_entry(entry, user)
      end
    end
  end

  def create_document_from_entry(entry, user)
    temp_file = Tempfile.new([entry.name, '.xml'])
    temp_file.binmode
    temp_file.write(entry.get_input_stream.read)
    temp_file.rewind

    document = Document.new(user: user)
    document.xml_file.attach(io: temp_file, filename: entry.name, content_type: 'text/xml')

    if document.save
      Rails.logger.info "Successfully processed #{entry.name}"
    else
      Rails.logger.error "Failed to save document: #{document.errors.full_messages.join(", ")}"
    end

    temp_file.close
    temp_file.unlink
  end

end
