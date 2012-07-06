class BusRoute < ActiveRecord::Base
  attr_accessible :directions, :name, :number

  validates :number, :name, :directions, :presence => true
  validates :number, :uniqueness => true
end
