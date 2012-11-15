class BusTrackerController < ApplicationController
  require 'bustracker_parser'

  def index
    @routes = BusRoute.all

    respond_to do |format|
      format.html  # index.html.erb
      format.json { render :json => @routes }
    end
  end

  def get_directions
    @route = BusRoute.find_by_number(params[:number])

    respond_to do |format|
      format.json { render :json => @route }
    end
  end

  def get_stops
    route_number = params[:number]
    direction = params[:direction]

    @bus_stops = BusStop.find_all_by_route_and_direction(route_number, direction)
    @bus_stops.sort! { |a,b| a.name <=> b.name }

    respond_to do |format|
      format.json { render :json => @bus_stops }
    end
  end

  def get_predictions

    @route = BusRoute.find_by_number(params[:number])
    @predictions = BusTrackerParser.get_predictions(@route.number, params[:stop_id])

    respond_to do |format|
      format.html
      format.json { render :json =>  @predictions }
    end
  end

  def time_until_arrival
    time = params[:time]

    @time_until_arrival = BusTrackerParser.time_until_arrival(Time.parse(time))

    respond_to do |format|
      format.json { render :json => @time_until_arrival }
    end
  end
end
