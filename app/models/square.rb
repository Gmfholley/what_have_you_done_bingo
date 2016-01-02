# == Schema Information
#
# Table name: squares
#
#  id          :integer          not null, primary key
#  position_x  :integer
#  position_y  :integer
#  picture     :string
#  question    :string
#  free_space  :boolean
#  template_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SquarePositionValidator < ActiveModel::EachValidator
 
  def validate_each(record, attribute, value)
   unless record.template_id && Template.find(record.template_id).size >= value && value >= 0
    record.errors(attribute, "cannot be less than 0 or greater than template size")
  end
end

class Square < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with SquarePositionValidator
  
  validates :position_x, :square_position => true
  validates :position_y, :square_position => true
  validates :question, presence: true
  validates :template, presence: true, 
  validates_uniqueness_of :template_id, :scope => [:position_x, :position_y]
  
  before_save :set_default_free_space, :if => :new_record?

  def set_default_free_space
    self.free_spzce ||= false
    return true
  end
  
  
end