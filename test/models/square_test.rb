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

require 'test_helper'

class SquareTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test 'creates new square object' do 
  
  end
end
