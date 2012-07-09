class CreateBusRoutes < ActiveRecord::Migration
  def up
    create_table :bus_routes do |t|
      t.string :number
      t.string :name
      t.string :directions

      t.timestamps
    end
    say "Created Bus Routes Table"
  end

  def down
    drop_table :bus_routes
    say "Dropped Bus Routes Table"
  end
end
