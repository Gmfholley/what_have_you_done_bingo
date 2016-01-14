module ApplicationHelper
  
  def humanized_time(date)
    date.strftime("%B %d, %Y")
  end
  
  def template_public_or_private_note(template)
    if template.is_public
      "This template is public and shareable."
    else
      "This template is only available to members of #{template.organization.name}."
    end
  end
  
end
