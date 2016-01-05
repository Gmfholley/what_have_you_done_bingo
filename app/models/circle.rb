# == Schema Information
#
# Table name: circles
#
#  id            :integer          not null, primary key
#  card_id       :integer
#  position_x    :integer
#  position_y    :integer
#  response      :string
#  question      :string
#  picture       :string
#  part_of_bingo :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Circle < ActiveRecord::Base
  validates_numericality_of :position_x, greater_than_or_equal_to: 0
  validates_numericality_of :position_y, greater_than_or_equal_to: 0
  validates :card, presence: true
  validates :value, presence: true
  validates :card_id, uniqueness: { scope: [:position_x, :position_y] }
  
  belongs_to :card
  belongs_to :user, through: :card
  belongs_to :template, through: :template
  
  after_initialize :set_default_part_of_bingo, :if => :new_record?
  
  # returns a boolean to indicate if the circle is marked
  #
  # returns boolean
  def marked?
    !self.response.blank?
  end
  
  private
  
  # sets part of bingo to false as default
  #
  # returns true (because if it is false, it sometimes gets in the problem of valid? callback)
  def set_default_part_of_bingo
    self.part_of_bingo ||= false
    return true
  end
  
end
