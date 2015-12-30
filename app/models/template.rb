# == Schema Information
#
# Table name: templates
#
#  id              :integer          not null, primary key
#  size            :integer
#  organization_id :integer
#  name            :string
#  rating          :string
#  public          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Template < ActiveRecord::Base
end
