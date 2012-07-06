class BusTrackerController < ApplicationController
  def index
    @routes = BusRoute.all
  end
end
