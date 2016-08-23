class DropFocalSlotPresTable < ActiveRecord::Migration
  def up
    drop_table :focal_slot_pres
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
