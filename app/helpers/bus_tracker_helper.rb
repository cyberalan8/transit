module BusTrackerHelper
  require 'bustracker_parser'

  def format_bus_routes(bus_route)
    bus_route.number + " - " + bus_route.name
  end

  def time_remaining(predicted_time)
    BusTrackerParser.time_until_arrival(predicted_time)
  end

  def translate_error error
    case error.to_s
    when 'getaddrinfo: nodename nor servname provided, or not known'
      'Network issues, we could not connect to CTA.'
    else
      "Unknown Error: #{error}"
    end
  end
end
