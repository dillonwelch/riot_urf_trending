task populate_static_champion_data: [:environment] do
  service = StaticChampionService.new
  puts I18n.t('tasks.populate_static_champion_data.delete')
  Champion.delete_all
  puts I18n.t('tasks.populate_static_champion_data.fetch')
  start_time = Time.zone.now
  service.populate_database
  end_time = Time.zone.now
  puts I18n.t('tasks.populate_static_champion_data.finish',
              time: end_time - start_time)
end

task :populate_match_data, [:match_id] => [:environment] do | _t, args |
  args.with_defaults(match_id: 1775710444)
  service = MatchService.new(args.match_id)
  puts I18n.t('tasks.populate_match_data.saving', match: args.match_id)
  begin
    service.populate_database
    puts I18n.t('tasks.populate_match_data.saved')
  rescue ActiveRecord::ActiveRecordError => error
    puts error
  rescue Lol::NotFound
    puts I18n.t('tasks.populate_match_data.not_found', match: args.match_id)
  end
end
