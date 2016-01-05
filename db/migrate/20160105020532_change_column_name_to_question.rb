class ChangeColumnNameToQuestion < ActiveRecord::Migration
  def change
    rename_column :circles, :value, :question
  end
end
