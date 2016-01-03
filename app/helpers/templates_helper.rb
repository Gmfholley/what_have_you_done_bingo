module TemplatesHelper
  
  def shareable_link(template)
    "#{root_url}play/#{template.token}"
  end
end
