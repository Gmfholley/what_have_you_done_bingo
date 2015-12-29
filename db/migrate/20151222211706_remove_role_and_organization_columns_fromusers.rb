class RemoveRoleAndOrganizationColumnsFromusers < ActiveRecord::Migration
  def change
    remove_column(:users, :organization_id)
    remove_column(:users, :role_id)
  end
end
