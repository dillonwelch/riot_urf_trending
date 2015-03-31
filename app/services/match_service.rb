class MatchService < RiotApiService
  attr_reader :match_id

  def initialize(match_id, region='na')
    super(region)
    @match_id = match_id
  end

  def match
    return @match unless @match.nil?
    @match = client.match.get(match_id)
    match = Match.create!(game_id: match_id,
                          champion_data: champion_data,
                          raw_api_data: @match)
    # champion_data.each do |data|
    #   ChampionMatch.create!(champion_id: data.first,
    #                         match_id: match.id,
    #                         victory: data.second)
    # end
  end

  def teams
    @teams ||= match['teams']
  end

  def team(team_id)
    teams.find{ |hash| hash.fetch('teamId') == team_id }
  end

  def team_won?(team_id)
    team(team_id).fetch('winner')
  end

  def participants
    @participants ||= match['participants']
  end

  def champion_data
    participants.collect do |participant|
      [
        participant.fetch('championId'),
        team_won?(participant.fetch('teamId'))
      ]
    end
  end
end
