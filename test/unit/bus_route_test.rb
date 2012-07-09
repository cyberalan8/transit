require 'test_helper'

class BusRouteTest < ActiveSupport::TestCase
  test "number is required" do
    bus_route = BusRoute.new(:number => nil, :name => "Here & There", :directions => "North Bound, South Bound")
    assert bus_route.valid? == false
  end

  test "name is required" do
    bus_route = BusRoute.new(:number => "8", :name => nil, :directions => "North Bound, South Bound")
    assert bus_route.valid? == false
  end

  test "direction is required" do
    bus_route = BusRoute.new(:number => nil, :name => "Here & There", :directions => nil)
    assert bus_route.valid? == false
  end

  test "number is unique" do
    already_created_bus = BusRoute.find_by_number('99')

    bus_route = BusRoute.new(:number => already_created_bus.number, :name => "Here & There", :directions => "North Bound, South Bound")
    assert bus_route.valid? == false
  end
end
