module BusTrackerHelper
  def format_bus_routes(bus_route)
    bus_route.number + " - " + bus_route.name
  end
end
