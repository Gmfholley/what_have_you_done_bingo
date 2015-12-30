class ChangeRatingsColumnToRating < ActiveRecord::Migration
  def change
    rename_column :templates, :ratings, :rating
  end
end
