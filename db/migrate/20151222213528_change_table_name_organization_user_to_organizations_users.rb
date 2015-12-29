class ChangeTableNameOrganizationUserToOrganizationsUsers < ActiveRecord::Migration
  def change
    rename_table(:organization_users, :organizations_users)
  end
  
end
