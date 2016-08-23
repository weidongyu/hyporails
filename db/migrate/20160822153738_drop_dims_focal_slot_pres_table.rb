class DropDimsFocalSlotPresTable < ActiveRecord::Migration
  def up
    drop_table :dims_focalSlotPres
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
