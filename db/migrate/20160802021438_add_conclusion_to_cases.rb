class AddConclusionToCases < ActiveRecord::Migration
  def change
    add_column :cases, :conclusion, :integer
  end
end
