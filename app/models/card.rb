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
  belongs_to :template
  belongs_to :user
  has_many :circles
  
  validates_numericality_of :num_bingos, :greater_than_or_equal_to => 0
  validates :template, presence: true
  validates :user, presence: true
  
  
  after_initialize :set_defaults
  before_create :generate_token
  
  private
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Organization.exists?(token: random_token)
    end
  end

  def set_defaults
    self.is_public ||= false
    self.num_bingos = 0
  end
  
end
