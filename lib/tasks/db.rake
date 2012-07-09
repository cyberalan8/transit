namespace :db do
  desc "Setup data"
  task :setup_data => :environment do
    puts 'Filling up the database...'
    require 'bustracker_parser'
    Rake::Task['db:import_bus_routes'].invoke
    puts "\n"
    Rake::Task['db:import_bus_stops'].invoke
  end

  desc "Nuke the database to start over"
  task :nuke_data => :environment do
    puts 'Nuking everthing . . .'
    Rake::Task['db:drop:all'].invoke
    puts "\n\n\t >> Putting the pieces back together..."
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts 'Done.'
  end

  desc "Import bus route data"
  task :import_bus_routes do
    puts "\t >> Importing bus route data."
    routes = BusTrackerParser.get_routes

    routes.each_with_index do |route, index|
      rt = route.first
      rtnm = route.last
      directions = BusTrackerParser.get_directions(rt)
      direction_insert = directions.join(',')
      BusRoute.create(:number => rt, :name => rtnm, :directions => direction_insert)
      print '.' if index % 10 == 0
    end
    puts "\n\t >> All Bus Routes (#{BusRoute.count}) have been successfully imported!"
  end

  desc "Import bus stop data"
  task :import_bus_stops do
    puts "\t >> Importing bus stop data."
    routes = BusRoute.all
    routes.each do |route|
      rt = route.number
      directions = route.directions.split(',')
      directions.each do |direction|
        stops = BusTrackerParser.get_stops(rt, direction)
        stops.each_with_index do |stop, index|
          stp = stop.last
          BusStop.create(:id => stp['id'], :name => stp['name'], :lat => stp['lat'], :lon => stp['lon'], :route => rt, :direction => direction)
          print '.' if index % 500 == 0
        end
      end
    end
    puts "\n\t >> All Bus Stops (#{BusStop.count}) have been successfully imported!"
  end
end
