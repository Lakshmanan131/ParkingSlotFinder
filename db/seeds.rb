# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
(1..4).each do |seed|
  Entrance.create(way:"Entrance #{seed}")
end

slot_no = 0
(1..4).each do |seeds|
  (1..10).each do |column|
    (1..25).each do |row|
      slot_no += 1
      Slot.create(slot_number: slot_no, slot_available: false , slot_distance: row + column, entrance_id: seeds)
    end
  end
end