# == Schema Information
#
# Table name: users
#
#  id                              :integer          not null, primary key
#  email                           :string           not null
#  crypted_password                :string
#  salt                            :string
#  created_at                      :datetime
#  updated_at                      :datetime
#  remember_me_token               :string
#  remember_me_token_expires_at    :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  reset_password_email_sent_at    :datetime
#  first_name                      :string
#  last_name                       :string
#  profile_picture                 :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#

class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  validates :password_confirmation, presence: true
  validates :password, confirmation: true, length: {minimum: 5}
  validates :email, presence: true, email: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  has_many :organization_users
  has_many :organizations, through: :organization_users
  
  # for an organization, returns the user's role (or nil if not found)
  #
  # organization - Organization object
  #
  # returns a Role object
  def role(organization)
    assoc = OrganizationUser.find_by(user_id: self.id, organization_id: organization.id) || OrganizationUser.new
    assoc.role
  end
  
end
