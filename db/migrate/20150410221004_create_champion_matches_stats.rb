class CreateChampionMatchesStats < ActiveRecord::Migration
  def change
    create_table :champion_matches_stats do |t|
      t.references :champion
      t.integer    :victories
      t.integer    :losses
      t.integer    :kills
      t.integer    :deaths
      t.integer    :assists
      t.bigint     :start_time

      t.timestamps
    end

    add_index :champion_matches_stats, [:champion_id, :start_time]
    add_foreign_key :champion_matches_stats, :champions,
      name: 'fk_rails_champion_matches_stats_champions', on_delete: :cascade
  end
end
