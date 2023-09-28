class SlotBookingsController < ApplicationController


  def index
    @slot_bookings = current_user.slot_bookings.includes([:slot]).where(active: true)
  end

  def new
    @slot_booking = SlotBooking.new
    get_entrance_slots
  end

  # def edit
  #   @slot_booking = SlotBooking.find(params[:id])
  #   @entrances = Entrance.all
  # end

  def create
    @slot_booking = SlotBooking.new(slot_booking_params.merge(user_id: current_user.id))
    nearest_slot = find_nearest_available_slot(@slot_booking.entrance_id)



    if nearest_slot.nil?
      get_entrance_slots
      render :new, notice: "No slots available"
    else
      @slot_booking.slot = nearest_slot
      nearest_slot.update(slot_available: true)

      if @slot_booking.save
        redirect_to root_path, notice: "Booking successful as nearest available slot is #{nearest_slot.slot_number}."

      else
        get_entrance_slots
        render :new, notice: "Booking failed"
      end
    end

  end


  def slot_allocation_history
    if params[:search].present?
      search = "%#{params[:search]}%"
      @allocation_history = SlotBooking.includes([:slot]).where("vehicle_registration_number LIKE ?", search)
    end
  end

  def slot_occupancy
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    @slot_bookings = SlotBooking.includes([:slot]).all

    if @from_date.present? && @to_date.present?
      @from_date = Date.parse(@from_date)
      @to_date = Date.parse(@to_date)

      if @from_date <= @to_date
        @slot_bookings = @slot_bookings.includes([:slot]).where(entry_time: @from_date.beginning_of_day..@to_date.end_of_day)
      else
        flash[:alert] = "Invalid date range: 'From Date' must be before or equal to 'To Date'."
      end
    end
  end


  def first_entry_times
    @first_entry_times = SlotBooking.group(:vehicle_registration_number).minimum(:entry_time)
  end

  def exit_parking
    @booking = SlotBooking.find(params[:id])
    @booking.slot.update(slot_available: false)
    @booking.update(active: false)
    redirect_to root_path,notice: "The vehicle has been left successfully"
  end

  private

  def filtered_by_date_range(slot_bookings, start_date, end_date)
    slot_bookings.where(entry_time: start_date..end_date)
  end

  def find_nearest_available_slot(entrance_id)
    entry = Entrance.find(entrance_id)
    available_slots = entry.slots.where(slot_available: false )

    if available_slots.empty?
      return nil
    end

    # calculate distance between the entrance and each slot

    nearest_slot = nil
    nearest_distance = nil

    available_slots.each do |slot|
      # I taking the slot distance for each slot from the DB.
      distance = slot.slot_distance

      # I calculate the distance between the entrance and the slot
      if nearest_distance.nil? || distance < nearest_distance
        nearest_slot = slot
        nearest_distance = distance
      end
    end

    nearest_slot
  end

  def get_entrance_slots
    @entrances = Entrance.all
    @slots = Slot.all
  end

  # strong parameters
  def slot_booking_params
    params.require(:slot_booking).permit(:entrance_id, :vehicle_registration_number, :phone_number).merge(entry_time: Time.now, active: true)

  end

end