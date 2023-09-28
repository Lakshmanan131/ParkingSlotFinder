class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.integer :slot_number
      t.boolean :slot_available
      t.integer :slot_distance
      t.references :entrance, null: false, foreign_key: true

      t.timestamps
    end
  end
end
