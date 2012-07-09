class CreateBusStops < ActiveRecord::Migration
  def up
    create_table :bus_stops do |t|
      t.string :id
      t.string :name
      t.float :lat
      t.float :lon
      t.string :route
      t.string :direction

      t.timestamps
    end
    say "Created Bus Stops Table"
    suppress_messages {add_index :bus_stops, :id}
  end

  def down
    drop_table :bus_stops
    say "Dropped Bus Stops Table"
  end
end
