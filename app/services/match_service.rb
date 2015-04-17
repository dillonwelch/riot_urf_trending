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
      sleep_time = 1
      puts I18n.t('services.rate_limit', count: sleep_time)
      sleep(sleep_time)
      match
    end
  end

  def teams
    @teams ||= match['teams']
  end

  def team(team_id)
    teams.detect { |hash| hash.fetch('teamId') == team_id }
  end

  def team_won?(team_id)
    team(team_id).fetch('winner')
  end

  def participants
    @participants ||= match['participants']
  end

  def participant(teamId, championId)
    participant = participants.find do |participant|
      participant.fetch('teamId') == teamId &&
        participant.fetch('championId') == championId
    end
  end

  def participant_stat(teamId, championId, stat_name)
    participant(teamId, championId).fetch('stats').fetch(stat_name)
  end

  def champion_data
    participants.map do |participant|
      {
        champion_id: participant.fetch('championId'),
        team_id: participant.fetch('teamId'),
        victory: team_won?(participant.fetch('teamId'))
      }
    end
  end

  def bans
    bans = []
    teams.each do |_team|
      _team.fetch('bans').each do |ban|
        bans << {
         champion_id: ban.fetch('championId'),
         team_id: _team.fetch('teamId'),
         pick_turn: ban.fetch('pickTurn')
        }
      end
    end
    bans
  end

  def champion_mapping
    return @c unless @c.nil?
    @c = {}
    Champion.find_each do |champion|
      @c[champion.riot_id] = champion.id
    end
    @c
  end

  def populate_database
    match_model = Match.create!(game_id: match_id,
                                champion_data: champion_data,
                                region: match.fetch('region'),
                                start_time: match.fetch('matchCreation'),
                                duration: match.fetch('matchDuration'))

    bans.each do |ban|
      MatchBan.create!(
        match_id: match_model.id,
        champion_id: champion_mapping.fetch(ban[:champion_id]),
        team_id: ban[:team_id],
        pick_turn: ban[:pick_turn])
    end

    MatchApiData.create!(match_id: match_model.id, raw_api_data: match)
    champion_data.each do |data|
      champion_id = champion_mapping.fetch(data[:champion_id])
      ChampionMatch.create!(champion_id: champion_id,
                            match_id: match_model.id,
                            team_id: data[:team_id],
                            kills: participant_stat(data[:team_id], data[:champion_id], 'kills'),
                            deaths: participant_stat(data[:team_id], data[:champion_id], 'deaths'),
                            assists: participant_stat(data[:team_id], data[:champion_id], 'assists'),
                            victory: data[:victory])
    end
  end
end
