class AddIndexForVictory < ActiveRecord::Migration
  def up
    execute %{
      create index index_champion_matches_on_victory_true on champion_matches
        (victory) where victory = true;

      create index index_champion_matches_on_victory_false on champion_matches
        (victory) where victory = false;
    }
  end

  def down
    execute %{
      drop index index_champion_matches_on_victory_true;
      drop index index_champion_matches_on_victory_false;
    }
  end
end
