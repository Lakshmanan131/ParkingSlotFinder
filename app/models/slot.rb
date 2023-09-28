class Slot < ApplicationRecord
  # =====================Associations================

  belongs_to :entrance
  has_many :slot_bookings

end
