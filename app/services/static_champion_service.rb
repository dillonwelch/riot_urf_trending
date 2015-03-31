class StaticChampionService < RiotApiService
  def champions
    @champions ||= client.static.champion.get(champData: 'all')
  end

  def populate_database
    Champion.transaction do
      champions.each do | champion |
        Champion.find_or_create_by(riot_id: champion.id) do | c |
          c.name = champion.name
          c.primary_role = champion.tags.first
          c.secondary_role = champion.tags.second
          c.raw_api_data = champion.to_json
        end
      end
    end
  end
end
