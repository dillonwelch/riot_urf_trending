class ChampionMatch < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  belongs_to :match
  validates :match, presence: true

  validates :victory, inclusion: [true, false]

  delegate :game_id, to: :match
  delegate :riot_id, to: :champion

  def self.find_by_game_id(game_id)
    joins(:match).where(matches: { game_id: game_id })
  end

  def self.find_by_riot_id(riot_id)
    joins(:champion).where(champions: { riot_id: riot_id })
  end

  def self.all_losses
    joins('
      left outer join (
        select count(victory) as losses, champion_id
        from champion_matches
        where victory = false
        group by champion_id
      ) as losses on losses.champion_id = champion_matches.champion_id
      '
    )
  end

  def self.all_wins
    joins('
      left outer join (
        select count(victory) as victories, champion_id
        from champion_matches
        where victory = true
        group by champion_id
      ) as victories on victories.champion_id = champion_matches.champion_id
      '
    )
  end

  def self.all_wins_and_losses
    select('coalesce(victories, 0) as victories, coalesce(losses, 0) as losses, name').
      all_wins.all_losses.
      joins('right outer join champions on champion_matches.champion_id = champions.id').
      group('name, victories, losses').
      order('name asc')
  end

  def self.n_most_played(n=5)
    select('coalesce(victories, 0) as victories, coalesce(losses, 0) as losses, name, coalesce((sum(victories + losses) / count(name))::int, 0) as total').
      all_wins.all_losses.
      joins('right outer join champions on champion_matches.champion_id = champions.id').
      group('name, victories, losses').
      order('total desc').
      limit(n)
  end

  def self.n_best(n=5)
    select('coalesce(victories, 0) as victories, coalesce(losses, 0) as losses, name, coalesce((victories::float / count(name)), 0) as win_rate').
      all_wins.all_losses.
      joins('right outer join champions on champion_matches.champion_id = champions.id').
      group('name, victories, losses').
      order('win_rate desc').
      limit(n)
  end
end
