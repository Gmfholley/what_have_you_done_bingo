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
#

class Template < ActiveRecord::Base
  enum rating: [:easy, :medium, :hard]
  belongs_to :organization
  validates_numericality_of :size, :in => 4..6
  validates :name, presence: true
  validates :organization, presence: true
  
  before_save :set_defaults

  def set_defaults
    self.size ||=  5
    self.is_public ||= false
  end
end
