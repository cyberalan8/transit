module BusTrackerHelper
  require 'bustracker_parser'

  def format_bus_routes(bus_route)
    bus_route.number + " - " + bus_route.name
  end

  def time_remaining(predicted_time)
    BusTrackerParser.time_until_arrival(predicted_time)
  end
end
