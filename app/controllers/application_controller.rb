class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @merged = ChampionMatch.find_by_sql('
      select coalesce(victories, 0) as victories, coalesce(losses, 0) as losses, name
      from champion_matches
      left outer join (
          select count(victory) as losses, champion_id
          from champion_matches
          where victory = false
          group by champion_id
      ) as losses on losses.champion_id = champion_matches.champion_id
      left outer join (
          select count(victory) as victories, champion_id
          from champion_matches
          where victory = true
          group by champion_id
      ) as victories on victories.champion_id = champion_matches.champion_id
      right outer join champions on champion_matches.champion_id = champions.id
      group by name, victories, losses
      order by champions.name
    ')
  end
end
