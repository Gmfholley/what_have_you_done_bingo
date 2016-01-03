json.array!(@cards) do |card|
  json.extract! card, :id, :template_id, :user_id, :token, :is_public, :num_bingos
  json.url card_url(card, format: :json)
end
