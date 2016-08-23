class RemoveTypeFromCases < ActiveRecord::Migration
  def change
    remove_column :cases, :type, :integer
  end
end
