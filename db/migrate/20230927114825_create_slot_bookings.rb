class CreateSlotBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :slot_bookings do |t|
      t.string :vehicle_registration_number
      t.bigint :phone_number
      t.datetime :entry_time
      t.boolean :active
      t.references :user, null: false, foreign_key: true
      t.references :entrance, null: false, foreign_key: true
      t.references :slot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
