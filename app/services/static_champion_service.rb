class StaticChampionService < RiotApiService
  def champions
    @champions ||= client.static.champion.get(champData: 'all')
  end

  def populate_database
    Champion.transaction do
      champions.each do |champion|
        champion_model = Champion.find_or_create_by(riot_id: champion.id) do |c|
          c.name = champion.name
          c.primary_role = champion.tags.first
          c.secondary_role = champion.tags.second
        end
        ChampionApiData.find_or_create_by(champion: champion_model) do |cad|
          cad.raw_api_data = champion.to_json
        end
      end
    end
  end
end
