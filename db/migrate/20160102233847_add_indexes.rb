class AddIndexes < ActiveRecord::Migration
  def change
    add_index :organizations, :token
    add_index :templates, :token
  end
end
