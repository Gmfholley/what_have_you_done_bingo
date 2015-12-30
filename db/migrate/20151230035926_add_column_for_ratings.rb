class AddColumnForRatings < ActiveRecord::Migration
  def change
    add_column :templates, :ratings, :integer
  end
end
