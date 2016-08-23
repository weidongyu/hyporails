class CreateFocals < ActiveRecord::Migration
  def change
    create_table :focals do |t|
      t.string :content

      t.timestamps null: false
    end

    create_table :dims_focals, id: false do |t|
      t.belongs_to :dim
      t.belongs_to :focal
    end
  end
end
