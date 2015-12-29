class AddColumn < ActiveRecord::Migration
  def change
    add_column(:users, :organization_id, :integer)
    add_column(:users, :role, :integer)
  end
end
