require 'test_helper'

class BusRouteTest < ActiveSupport::TestCase
  test "route_number is required" do
    bus_route = BusRoute.new(:route_number => nil, :route_name => "Here & There", :route_directions => "North Bound, South Bound")
    assert bus_route.valid? == false
  end

  test "route_name is required" do
    bus_route = BusRoute.new(:route_number => "8", :route_name => nil, :route_directions => "North Bound, South Bound")
    assert bus_route.valid? == false
  end

  test "route_direction is required" do
    bus_route = BusRoute.new(:route_number => nil, :route_name => "Here & There", :route_directions => nil)
    assert bus_route.valid? == false
  end
  test "route_number is unique" do
    already_created_bus_route = BusRoute.create(:route_number => "8", :route_name => "Here & There", :route_directions => "North Bound, South Bound")

    bus_route = BusRoute.new(:route_number => "8", :route_name => "Here & There", :route_directions => "North Bound, South Bound")
    assert bus_route.valid? == false
  end
end
