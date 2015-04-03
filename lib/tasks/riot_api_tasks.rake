task populate_static_champion_data: [:environment] do
  service = StaticChampionService.new
  puts I18n.t('tasks.populate_static_champion_data.fetch')
  start_time = Time.zone.now
  service.populate_database
  end_time = Time.zone.now
  puts I18n.t('tasks.populate_static_champion_data.finish',
              time: end_time - start_time)
end

task :populate_match_data, [:match_id, :region] => [:environment] do | _t, args |
  service = MatchService.new(args.match_id, args.region)
  if Match.find_by(game_id: args.match_id, region: args.region.upcase).nil?
    begin
      puts I18n.t('tasks.populate_match_data.saving', match: args.match_id)
      service.populate_database
      puts I18n.t('tasks.populate_match_data.saved')
    rescue ActiveRecord::ActiveRecordError => e
      puts e
      puts "Match #{args.match_id} already saved."
    rescue Lol::NotFound
      puts I18n.t('tasks.populate_match_data.not_found', match: args.match_id)
    end
  end
end

task :riot_seed_data do
  Rake::Task['populate_static_champion_data'].invoke
  [1775710444, 1775668751, 1775635895, 1775611478, 1775555666].each do |match|
    Rake::Task['populate_match_data'].reenable
    Rake::Task['populate_match_data'].invoke(match, 'na')
  end
end

task get_urf_matches: [:environment] do
  regions = %w(br eune euw kr lan las na oce ru tr)
  time = (Time.at ((Time.zone.now - 10.minutes).to_f / 5.minutes).floor * 5.minutes).to_i
  regions.each do |region|
    puts I18n.t('tasks.get_urf_matches.fetch_list', region: region)
    begin
      service = ApiChallengeService.new(
        beginDate: time,
        region: region
      )
      puts I18n.t('tasks.get_urf_matches.fetch_matches', count: service.matches.count)
      service.matches.each do |match|
        begin
          Rake::Task['populate_match_data'].reenable
          Rake::Task['populate_match_data'].invoke(match, region)
        rescue Lol::NotFound => e
          puts 'Error in match'
          puts e
        end
      end
    rescue Lol::NotFound => e
      puts 'Error in urf api'
      puts e
    end
  end
end
