module CardsHelper
  
  def template_link(template)
    "#{root_url}play/#{template.token}"
  end
  
  def card_link(card)
    "#{root_url}share/#{card.token}"
  end
  
  def template_public_or_private_note(template)
    if template.is_public
      "This template is public and shareable."
    else
      "This template is only available to members of #{template.name}."
    end
  end
end
