class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer :card_id
      t.integer :position_x
      t.integer :position_y
      t.string :response
      t.string :value
      t.string :picture
      t.boolean :part_of_bingo

      t.timestamps null: false
    end
  end
end
