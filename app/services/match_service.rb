class MatchService < RiotApiService
  attr_reader :match_id

  def initialize(match_id, region='na')
    super(region)
    @match_id = match_id
  end

  def match
    return @match unless @match.nil?
    begin
      @match = client.match.get(match_id)
    rescue Lol::InvalidAPIResponse => e
      puts I18n.t('services.rate_limit', seconds: 10)
      sleep(10)
      match
    end
  end

  def teams
    @teams ||= match['teams']
  end

  def team(team_id)
    teams.detect { | hash | hash.fetch('teamId') == team_id }
  end

  def team_won?(team_id)
    team(team_id).fetch('winner')
  end

  def participants
    @participants ||= match['participants']
  end

  def champion_data
    participants.map do | participant |
      {
        champion_id: participant.fetch('championId'),
        team_id: participant.fetch('teamId'),
        victory: team_won?(participant.fetch('teamId'))
      }
    end
  end

  def populate_database
    match_model = Match.create!(game_id: match_id,
                                champion_data: champion_data,
                                region: match.fetch('region'),
                                raw_api_data: match,
                                start_time: match.fetch('matchCreation'),
                                duration: match.fetch('matchDuration'))
    champion_data.each do | data |
      champion_id = Champion.find_by_riot_id(data[:champion_id]).id
      ChampionMatch.create!(champion_id: champion_id,
                            match_id: match_model.id,
                            team_id: data[:team_id],
                            victory: data[:victory])
    end
  end
end
