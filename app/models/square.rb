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

class SquarePositionValidator < ActiveModel::Validator
 
  def validate(record)
    size = template_size(record)
    this_position(record, :position_x, size)
    this_position(record, :position_y, size)
  end
  
  private  
  def template_size(record)
    if record.template.blank?
      Template.largest_size
    else
      record.template.size
    end
  end
  
  def this_position(record, attribute, value)
    unless !record.send(attribute).blank? && record.send(attribute) >=0 && record.send(attribute) < value
      record.errors.add attribute, "cannot be less than 0 or greater than template size"
    end
  end
  
  
end

class Square < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with SquarePositionValidator
  
  validates :question, presence: true
  validates :template_id, uniqueness: { scope: [:position_x, :position_y] }
  # validates :template, presence: true
  
  belongs_to :template

  before_save :set_default_free_space, :if => :new_record?

  def set_default_free_space
    self.free_space ||= false
    return true
  end
end