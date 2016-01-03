class AddIndex < ActiveRecord::Migration
  def change
    add_index :cards, :token
  end
end
