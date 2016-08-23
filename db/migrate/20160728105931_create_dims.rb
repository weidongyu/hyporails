class CreateDims < ActiveRecord::Migration
  def change
    create_table :dims do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :dims_pres, id: false do |t|
      t.belongs_to :dim
      t.belongs_to :pre
    end
  end
end
