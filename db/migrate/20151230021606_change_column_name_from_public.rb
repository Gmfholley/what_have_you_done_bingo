class ChangeColumnNameFromPublic < ActiveRecord::Migration
  def change
    rename_column(:templates, :public, :is_public)
  end
end
