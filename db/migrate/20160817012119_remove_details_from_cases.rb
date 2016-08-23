class RemoveDetailsFromCases < ActiveRecord::Migration
  def change
    remove_column :cases, :claims, :string
    remove_column :cases, :focalSlot, :string
    remove_column :cases, :comparisonType, :string
    remove_column :cases, :proDir, :string

  end
end
