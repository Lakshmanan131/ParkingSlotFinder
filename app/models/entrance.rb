class Entrance < ApplicationRecord
  # =================Associations================

  has_many :slots
  has_many :slot_bookings


end
