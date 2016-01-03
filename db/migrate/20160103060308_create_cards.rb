class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :template_id
      t.integer :user_id
      t.string :token
      t.boolean :is_public
      t.integer :num_bingos

      t.timestamps null: false
    end
  end
end
