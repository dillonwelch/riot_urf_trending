class StaticChampionService < RiotApiService
  def champions
    @champions ||= client.static.champion.get(champData: 'all')
  end

  def populate_database
    Champion.transaction do
      champions.each do | champion |
        Champion.create!(riot_id: champion.id,
                         name: champion.name,
                         raw_api_data: champion.to_json,
                         primary_role: champion.tags.first,
                         secondary_role: champion.tags.second)
      end
    end
  end
end
