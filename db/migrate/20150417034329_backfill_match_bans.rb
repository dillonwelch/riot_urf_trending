class BackfillMatchBans < ActiveRecord::Migration
  def up
    c = {}
    champions = Champion.find_each do |champion|
      c[champion.riot_id] = champion.id
    end

    Match.find_each do |match|
      begin
        raw = match.match_api_data.raw_api_data
        unless raw.nil?
          raw_data = raw.to_hash
          raw_data.fetch('teams').each do |team|
            bans = team['bans']
            unless bans.nil?
              bans.each do |ban|
                MatchBan.create!(
                  match_id:    match.id,
                  champion_id: c.fetch(ban.fetch('championId')),
                  team_id:     team.fetch('teamId'),
                  pick_turn:   ban.fetch('pickTurn'))
              end
            end
          end
        end
      rescue NoMethodError
        next
      end
    end
  end

  def down
    MatchBan.delete_all
  end
end
