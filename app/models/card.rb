# == Schema Information
#
# Table name: cards
#
#  id          :integer          not null, primary key
#  template_id :integer
#  user_id     :integer
#  token       :string
#  is_public   :boolean
#  num_bingos  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_cards_on_token  (token)
#

class Card < ActiveRecord::Base
end
