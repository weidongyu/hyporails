class AddDetailsToDims < ActiveRecord::Migration
  def change
    add_column :dims, :claims, :string
    add_column :dims, :focalSlot, :string
    add_column :dims, :proPlDr, :string
    add_column :dims, :compType, :string
  end
end
