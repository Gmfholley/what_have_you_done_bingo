# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  size            :integer
#  organization_id :integer
#  name            :string
#  is_public       :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  token           :string
#  rating          :integer
#
# Indexes
#
#  index_templates_on_token  (token)
#

class Template < ActiveRecord::Base
  validates_numericality_of :size, :greater_than_or_equal_to => 4, :less_than_or_equal_to => 6
  validates :name, presence: true
  validates :organization, presence: true

  enum rating: [:easy, :medium, :hard]
  belongs_to :organization
  has_many :squares
  
  after_initialize :set_defaults
  # before_validation :set_defaults
  before_create :generate_token
  
  accepts_nested_attributes_for :squares
  # returns the number of bingo squares this bingo card template should have, based on the size
  #
  # returns an integer
  def num_squares
    self.size ** 2
  end
  
  # generates a token for itself for public sharing
  #
  # returns a string
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Organization.exists?(token: random_token)
    end
  end
  
  private
  # sets default values of self
  #
  # returns nothing
  def set_defaults
    # By the way, this method can NEVER return false or the method will return invalid, without an error message.  Yay!
    self.is_public ||= false
    self.size ||=  5
    true
  end
end
