module CardsHelper
  
  def template_link(template)
    "#{root_url}play/#{template.token}"
  end
  
  def card_link(card)
    "#{root_url}share/#{card.token}"
  end
end
