task populate_static_champion_data: [:environment] do
  service = StaticChampionService.new
  puts 'Deleting old champion data.'
  Champion.delete_all
  puts 'Fetching current champion data.'
  start_time = Time.zone.now
  service.populate_database
  end_time = Time.zone.now
  puts "Service took #{end_time - start_time} seconds."
end
