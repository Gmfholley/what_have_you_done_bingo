class CreateOrganizationUsers < ActiveRecord::Migration
  def change
    create_table :organization_users do |t|
      t.integer :organization_id
      t.integer :user_id
      t.integer :role_id

      t.timestamps null: false
    end
  end
end
