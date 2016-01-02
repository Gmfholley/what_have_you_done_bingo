# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  token      :string
#
# Indexes
#
#  index_organizations_on_token  (token)
#

class Organization < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :templates
  has_many :organization_users
  has_many :users, through: :organization_users
  accepts_nested_attributes_for :users, reject_if: :all_blank
  
  before_create :generate_token


  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Organization.exists?(token: random_token)
    end
  end
end
