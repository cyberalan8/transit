require 'open-uri'

module BusTrackerParser
  def BusTrackerParser.cta_time
    time = Nokogiri::XML(open("http://www.ctabustracker.com/bustime/api/v1/gettime?key=" + api_key))

    Time.parse(time.xpath("//tm").text)
  end

  def BusTrackerParser.get_routes
    routes = {}
    routes_dump = Nokogiri::XML(open("http://www.ctabustracker.com/bustime/api/v1/getroutes?key=" + api_key))

    routes_dump.xpath("//route").each do |route|
      routes.merge!("#{route.children.children.first.text}" => "#{route.children.children.last.text}")
      # TO DO:
      # write to db
    end

    routes
  end

  def BusTrackerParser.get_directions(route)
    directions = []
    directions_dump = Nokogiri::XML(open("http://www.ctabustracker.com/bustime/api/v1/getdirections?key=" + api_key + "&rt=" + route))

    directions_dump.xpath('//dir').each do |directional|
      directions << directional.children.text
    end

    directions
  end

  def BusTrackerParser.get_stops(route, direction)
    stops = {}
    stops_dump = Nokogiri::XML(open("http://www.ctabustracker.com/bustime/api/v1/getstops?key=" + api_key + "&rt=" + route + "&dir=" + variable_spacer(direction) ))

    stops_dump.xpath("//stop").each do |stop|
      temp = {'id' => stop.children.children[0].text, 
        'name' => stop.children.children[1].text, 
        'lat' => stop.children.children[2].text, 
        'lon' => stop.children.children[3].text}

      stops.merge!("#{stop.children.children.first.text}" => temp)
    end

    stops
  end

  def BusTrackerParser.get_predictions(route, stop_id)
    predictions = {}
    predictions_dump = Nokogiri::XML(open("http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=" + api_key + "&rt=" + route + "&stpid=" + stop_id))
    
    predictions_dump.xpath("//prd").each_with_index do |prediction, index|
      temp = {'vehicle_id' => prediction.children.children[4].text, 
        'distance' => prediction.children.children[5].text, 
        'destination' => prediction.children.children[8].text, 
        'predicted_time' => Time.parse(prediction.children.children[9].text)}

      predictions.merge!(index => temp)
    end

    predictions
  end

  def BusTrackerParser.get_vehicle(vehicle_id)
    vehicle = {}
    vehicle_dump = Nokogiri::XML(open("http://www.ctabustracker.com/bustime/api/v1/getvehicles?key=" + api_key + "&vid=" + vehicle_id))

    vehicle_dump.xpath("//vehicle").each do |prediction|
      temp = {'vehicle_id' => prediction.children.children[0].text, 
        'lat' => prediction.children.children[2].text, 
        'lon' => prediction.children.children[3].text, 
        'destination' => prediction.children.children[7].text}

      vehicle.merge!(prediction.children.children[0].text => temp)
    end

    vehicle
  end

  def BusTrackerParser.time_until_arrival(time)
    ((time - BusTrackerParser.cta_time ) / 60).round
  end

  private

  def BusTrackerParser.api_key
    #put your key here!
  end

  def BusTrackerParser.variable_spacer(variable)
    variable.gsub(' ', '%20')
  end
end
