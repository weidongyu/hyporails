class CreatePres < ActiveRecord::Migration
  def change
    create_table :pres do |t|
      t.string :content

      t.timestamps null: false
    end

    create_table :cases_pres, id: false do |t|
      t.belongs_to :case
      t.belongs_to :pre
    end
  end
end
