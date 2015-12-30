class AddTokenColumnToTemplate < ActiveRecord::Migration
  def change
    add_column(:templates, :token, :string)
  end
end
