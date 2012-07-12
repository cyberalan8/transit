class BusTrackerController < ApplicationController
  require 'bustracker_parser'

  def index
    @routes = BusRoute.all

    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @routes }
    end
  end

  def get_directions
    @route = BusRoute.find_by_number(params[:number])

    respond_to do |format|
      format.json  { render :json => @route }
    end
  end

  def get_stops
    route_number = params[:number]
    direction = params[:direction]

    @bus_stops = BusStop.find_all_by_route_and_direction(route_number, direction)
    @bus_stops.sort! { |a,b| a.name <=> b.name }

    respond_to do |format|
      format.json  { render :json => @bus_stops }
    end
  end

  def get_predictions

    route_number = params[:number]
    stop_id = params[:stop_id]

    @predictions = BusTrackerParser.get_predictions(route_number, stop_id)

    respond_to do |format|
      format.json  { render :json =>  @predictions }
    end
  end

  def get_cta_time
    @cta_time = BusTrackerParser.cta_time

    respond_to do |format|
      format.json { render :json => @cta_time }
    end
  end
end
