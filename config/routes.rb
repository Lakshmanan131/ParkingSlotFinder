Rails.application.routes.draw do

  devise_for :users
  resources :slot_bookings

  get 'slot_occupancy', to: 'slot_bookings#slot_occupancy'
  get 'first_entry_times', to: 'slot_bookings#first_entry_times'
  post 'exit_parking/:id', to: 'slot_bookings#exit_parking', as: "exit_parking"
  get 'slot_allocation_history', to: 'slot_bookings#slot_allocation_history'

  root 'slot_bookings#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
