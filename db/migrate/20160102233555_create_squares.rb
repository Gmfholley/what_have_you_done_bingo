class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.integer :position_x
      t.integer :position_y
      t.string :picture
      t.string :question
      t.boolean :free_space
      t.integer :template_id

      t.timestamps null: false
    end
  end
end
