class BusStop < ActiveRecord::Base
  attr_accessible :direction, :lat, :lon, :name, :route, :stop_id

  validates :direction, :lat, :lon, :name, :route, :stop_id, :presence => true
end
