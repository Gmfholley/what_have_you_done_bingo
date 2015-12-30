class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :size
      t.integer :organization_id
      t.string :name
      t.string :rating
      t.boolean :public

      t.timestamps null: false
    end
  end
end
