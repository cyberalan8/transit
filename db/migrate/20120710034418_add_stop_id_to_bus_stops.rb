class AddStopIdToBusStops < ActiveRecord::Migration
  def up
    add_column :bus_stops, :stop_id, :string, :after => :id
    suppress_messages {remove_index :bus_stops, :id}
    suppress_messages {add_index :bus_stops, :stop_id}
  end

  def down
    suppress_messages {add_index :bus_stops, :id}
    suppress_messages {remove_index :bus_stops, :stop_id}
    remove_column :bus_stops, :stop_id
  end
end
