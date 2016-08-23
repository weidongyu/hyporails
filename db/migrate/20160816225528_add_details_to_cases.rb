class AddDetailsToCases < ActiveRecord::Migration
  def change
    add_column :cases, :claims, :string
    add_column :cases, :focalSlot, :string
    add_column :cases, :comparisonType, :string
    add_column :cases, :proDir, :string
  end
end
