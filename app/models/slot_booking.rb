class SlotBooking < ApplicationRecord
  belongs_to :entrance
  belongs_to :user
  belongs_to :slot

  # =======================validates================
  validates :vehicle_registration_number, presence: true
  validates :phone_number, presence: true

  validate :parking_entry_once_per_day

  private

  def parking_entry_once_per_day
    return unless vehicle_registration_number.present? && entry_time.present?

    # Check if there is another booking for the same vehicle and date
    already_booked = SlotBooking.where(vehicle_registration_number: vehicle_registration_number)
                                .where('entry_time >= ? AND entry_time <= ?', entry_time.beginning_of_day, entry_time.end_of_day)
                                .where.not(id: id) # Exclude the current booking

    if already_booked.exists?
      errors.add(:vehicle_registration_number, 'Vehicle can enter parking only once per day')
    end
  end
end
