require 'test_helper'

class BusStopTest < ActiveSupport::TestCase
  test "direction is required" do
    bus_stop = BusStop.new(:direction => nil, :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => '66', :stop_id =>'1234')
    assert bus_stop.valid? == false
  end

  test "lat is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :lat => nil, :lon => 2.5, :name => "Test Street", :route => '66', :stop_id => '1234')
    assert bus_stop.valid? == false
  end

  test "lon is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :lat => 1.5, :lon => nil, :name => "Test Street", :route => '66', :stop_id => '1234')
    assert bus_stop.valid? == false
  end

  test "name is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :lat => 1.5, :lon => 2.5, :name => nil, :route => '66', :stop_id => '1234')
    assert bus_stop.valid? == false
  end

  test "route is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => nil, :stop_id => '1234')
    assert bus_stop.valid? == false
  end

  test "stop_id is required" do
     bus_stop = BusStop.new(:direction => 'North Bound', :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => nil, :stop_id => nil)
    assert bus_stop.valid? == false
  end
end
