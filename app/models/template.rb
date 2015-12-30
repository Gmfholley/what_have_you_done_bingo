# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  size            :integer
#  organization_id :integer
#  name            :string
#  rating          :string
#  is_public       :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  token           :string
#

class Template < ActiveRecord::Base
  validates_numericality_of :size, :in => 4..6
  validates :name, presence: true
  validates :organization, presence: true

  enum rating: [:easy, :medium, :hard]
  belongs_to :organization
  
  before_save :set_defaults
  before_create :generate_token

  # generates a token for itself for public sharing
  #
  # returns a string
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Organization.exists?(token: random_token)
    end
  end
  
  # sets default values of self
  #
  # returns nothing
  def set_defaults
    self.size ||=  5
    self.is_public ||= false
  end
  
  # returns the number of bingo squares this bingo card template should have, based on the size
  #
  # returns an integer
  def num_squares
    self.size ** 2
  end
end
