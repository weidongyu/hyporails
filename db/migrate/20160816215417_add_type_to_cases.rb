class AddTypeToCases < ActiveRecord::Migration
  def change
    add_column :cases, :type, :integer
  end
end
