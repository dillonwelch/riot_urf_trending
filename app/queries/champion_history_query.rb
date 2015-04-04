class ChampionHistoryQuery
  def initialize(champion_id:, start_time:, hours: 6)
    @champion_id = champion_id
    @hours = hours
    @start_time = start_time
  end

  def run
    queries = []
    (0..hours - 1).each do |hour|
      my_time = start_time - hour.hours
      query = one_hour_query(champion_id: champion_id,
                             start_time: my_time,
                             end_time:   my_time + 1.hour,
                             hour: hour + 1)
      queries << query
    end
    ActiveRecord::Base.connection.execute(queries.join(' UNION ALL '))
  end

  private

  attr_reader :champion_id, :start_time, :hours

  def one_hour_query(champion_id:, start_time:, end_time:, hour:)
    ActiveRecord::Base.send(
      :sanitize_sql_array,
      [
        %q(
          SELECT
          coalesce(victories, 0) as victories,
          coalesce(losses, 0) as losses,
          champion_matches.champion_id,
          coalesce((victories::float / (victories + losses)) * 100, 0) as win_rate,
          :hour as time
          FROM "champion_matches"
          -- INNER JOIN "matches" ON "matches"."id" = "champion_matches"."match_id"
          left outer join (
              select count(victory) as victories, champion_id
              from champion_matches
              join matches on champion_matches.match_id = matches.id
              where victory = true
              and ( ( start_time + duration * 1000) >= :start_time )
              and ( ( start_time + duration * 1000) < :end_time )
              group by champion_id
          ) as victories on victories.champion_id = champion_matches.champion_id left outer join (
              select count(victory) as losses, champion_id
              from champion_matches
              join matches on champion_matches.match_id = matches.id
              where victory = false
              and ( ( start_time + duration * 1000) >= :start_time )
              and ( ( start_time + duration * 1000) < :end_time )
              group by champion_id
          ) as losses on losses.champion_id = champion_matches.champion_id
          right outer join champions on champion_matches.champion_id = champions.id
          -- WHERE (( ( start_time + duration * 1000) >= :start_time )
          --       and ( ( start_time + duration * 1000) < :end_time ))
          --       AND champion_matches.champion_id = :champion_id
          where champions.id = :champion_id
          GROUP BY champion_matches.champion_id, victories, losses
        ),
        champion_id: champion_id,
        start_time: start_time.to_i * 1000,
        end_time: end_time.to_i * 1000,
        hour: hour
      ]
    )
  end
end
