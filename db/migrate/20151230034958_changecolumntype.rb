class Changecolumntype < ActiveRecord::Migration
  def change
    change_column :templates, :rating, :integer
  end
end
