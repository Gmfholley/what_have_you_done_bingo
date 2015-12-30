class RemoveColumnsRating < ActiveRecord::Migration
  def change
    remove_column :templates, :rating
  end
end
