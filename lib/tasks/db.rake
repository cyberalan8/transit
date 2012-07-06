namespace :db do
  desc "Setup data"
  task :setup_data => :environment do
    puts 'Filling up the database . . .'
    require 'bustracker_parser'
    routes = BusTrackerParser.get_routes

    routes.each do |route|
      rt = route.first
      rtnm = route.last
      directions = BusTrackerParser.get_directions(rt)
      direction_insert = directions.join(',')
      BusRoute.create(:number => rt, :name => rtnm, :directions => direction_insert)
    end;nil
    puts 'Success.'
  end

  desc "Nuke the database to start over"
  task :nuke_data => :environment do
    puts 'Nuking everthing . . .'
    Rake::Task['db:drop:all'].invoke
    puts 'Putting the pieces back together . . .'
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts 'Done.'
  end
end
