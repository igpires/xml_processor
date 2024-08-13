module ApplicationHelper
  def file_url(file)
    if file.attached?
      Rails.application.routes.url_helpers.url_for(file)
    else
      ''
    end
  end
end
