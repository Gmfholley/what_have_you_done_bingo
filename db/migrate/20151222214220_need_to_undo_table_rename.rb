class NeedToUndoTableRename < ActiveRecord::Migration
  def change
    rename_table(:organizations_users, :organization_users)
    
  end
end
