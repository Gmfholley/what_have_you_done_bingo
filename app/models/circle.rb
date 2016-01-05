# == Schema Information
#
# Table name: circles
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  position_x    :integer
#  position_y    :integer
#  response      :string
#  value         :string
#  picture       :string
#  part_of_bingo :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Circle < ActiveRecord::Base
end
