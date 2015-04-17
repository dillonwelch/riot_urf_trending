class CreateMatchBan < ActiveRecord::Migration
  def change
    create_table :match_bans do |t|
      t.references :champion
      t.references :match
      t.integer    :team_id
      t.integer    :pick_turn
    end

    add_index :match_bans, [:champion_id]
    add_index :match_bans, [:match_id, :champion_id]
    add_foreign_key :match_bans, :champions, name: 'fk_rails_match_bans_champions', on_delete: :cascade
    add_foreign_key :match_bans, :matches, name: 'fk_rails_match_bans_matches', on_delete: :cascade
  end
end
