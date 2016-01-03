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
    position(record, :position_x, template_size(record))
    position(record, :position_y, template_size(record))
  end
  
  def template_size(record)
    if record.template.blank?
      0
    else
      record.template.size
    end
  end
  
  def position(record, attribute, value)
    unless self.template_id && self.send(attribute) >=0 && self.send(attribute) < value
      self.errors(attribute, "cannot be less than 0 or greater than template size")
    end
  end
  
  
end

class Square < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with SquarePositionValidator
  #
  validates :question, presence: true
  validates_uniqueness_of :template_id, :scope => [:position_x, :position_y]
  #
  belongs_to :template

  before_save :set_default_free_space, :if => :new_record?

  def set_default_free_space
    self.free_space ||= false
    return true
  end
  
  
end