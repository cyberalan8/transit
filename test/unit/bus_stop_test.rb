require 'test_helper'

class BusStopTest < ActiveSupport::TestCase
  test "direction is required" do
    bus_stop = BusStop.new(:direction => nil, :id => "1", :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => '66')
    assert bus_stop.valid? == false
  end

  test "id is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :id => nil, :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => '66')
    assert bus_stop.valid? == false
  end

  test "lat is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :id => "1", :lat => nil, :lon => 2.5, :name => "Test Street", :route => '66')
    assert bus_stop.valid? == false
  end

  test "lon is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :id => "1", :lat => 1.5, :lon => nil, :name => "Test Street", :route => '66')
    assert bus_stop.valid? == false
  end

  test "name is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :id => "1", :lat => 1.5, :lon => 2.5, :name => nil, :route => '66')
    assert bus_stop.valid? == false
  end

  test "stop is required" do
    bus_stop = BusStop.new(:direction => 'North Bound', :id => "1", :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => nil)
    assert bus_stop.valid? == false
  end

  test "id is unique" do
    already_created_stop = BusStop.find_by_id('101010')

    bus_stop = BusStop.new(:direction => 'North Bound', :id => already_created_stop.id, :lat => 1.5, :lon => 2.5, :name => "Test Street", :route => '8')
    assert bus_stop.valid? == false
  end
end
