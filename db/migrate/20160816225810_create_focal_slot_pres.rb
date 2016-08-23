class CreateFocalSlotPres < ActiveRecord::Migration
  def change
    create_table :focal_slot_pres do |t|
      t.string :content

      t.timestamps null: false
    end

    create_table :dims_focalSlotPres, id: false do |t|
      t.belongs_to :dim
      t.belongs_to :focal_slot_pres
    end
  end
end
