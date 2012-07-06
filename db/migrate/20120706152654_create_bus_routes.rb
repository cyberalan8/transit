class CreateBusRoutes < ActiveRecord::Migration
  def change
    create_table :bus_routes do |t|
      t.string :number
      t.string :name
      t.string :directions

      t.timestamps
    end
  end
end
