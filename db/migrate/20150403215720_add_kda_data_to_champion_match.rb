class AddKdaDataToChampionMatch < ActiveRecord::Migration
  def change
    add_column :champion_matches, :kills, :integer
    add_column :champion_matches, :deaths, :integer
    add_column :champion_matches, :assists, :integer

    add_index :champion_matches, :kills
    add_index :champion_matches, :deaths
    add_index :champion_matches, :assists

    Match.all.each do |match|
      raw = match.raw_api_data
      unless raw.nil?
        raw_data = raw.to_hash
        participants = raw_data.fetch('participants')
        champion_matches = match.champion_matches
        unless champion_matches.empty?
          participants.each do |participant|
            cm = champion_matches.find do |cm|
              cm.team_id == participant.fetch('teamId') &&
                cm.champion.riot_id == participant.fetch('championId')
            end
            cm.kills =   participant.fetch('stats').fetch('kills')
            cm.deaths =  participant.fetch('stats').fetch('deaths')
            cm.assists = participant.fetch('stats').fetch('assists')
            cm.save!
          end
        else
          puts "No champion_matches for match #{match.id}."
        end
      else
        puts "No raw API data for match #{match.id}."
      end
    end
  end
end
