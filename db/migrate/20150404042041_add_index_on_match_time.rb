class AddIndexOnMatchTime < ActiveRecord::Migration
  def up
    execute %{
      drop index if exists index_matches_on_match_time;
      create index index_matches_on_match_time on matches((start_time + (duration * 1000)));
    }
  end

  def down
    execute "drop index index_matches_on_match_time;"
  end
end
