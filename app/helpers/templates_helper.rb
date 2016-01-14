module TemplatesHelper
  
  def shareable_link(template)
    "#{root_url}play/#{template.token}"
  end
  
  def public_or_private(template)
    if template.is_public
      "Public"
    else
      "Private (only visible to members)"
    end
  end
end
