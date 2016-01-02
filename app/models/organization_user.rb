# == Schema Information
#
# Table name: organization_users
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  user_id         :integer
#  role_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OrganizationUser < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  belongs_to :role
  
  validates :user, presence: true
  validates :role, presence: true
  validates :organization, presence: true
  validates_uniqueness_of :user, scope: :organization
  
  accepts_nested_attributes_for :users, reject_if: :all_blank
  
  
  before_save :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= Role.user
  end
  
end
