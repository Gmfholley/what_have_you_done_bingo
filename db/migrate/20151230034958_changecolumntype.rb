class Changecolumntype < ActiveRecord::Migration
  def change
    change_column :templates, :rating, 'integer USING CAST(rating AS integer)'
  end
end
