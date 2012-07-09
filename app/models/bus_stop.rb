class BusStop < ActiveRecord::Base
  attr_accessible :direction, :id, :lat, :lon, :name, :route

  validates :direction, :id, :lat, :lon, :name, :route, :presence => true
  validates :id, :uniqueness => true
end
