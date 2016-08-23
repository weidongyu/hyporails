class AddKindToCases < ActiveRecord::Migration
  def change
    add_column :cases, :kind, :integer
  end
end
