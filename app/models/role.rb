# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  validates :name, presence: true
  has_many :organization_users
  
  
  # finds Role id with a name of admin
  #
  # returns an integer
  def self.admin
    role = Role.find_by(name: 'admin') || Role.new
  end

  # finds Role id with a name of user
  #
  # returns an integer  
  def self.user
    role = Role.find_by(name: 'user') || Role.new
  end
  
end
