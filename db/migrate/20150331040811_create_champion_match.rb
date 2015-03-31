class CreateChampionMatch < ActiveRecord::Migration
  def change
    create_table :champion_matches do |t|
      t.references :champion
      t.references :match
      t.boolean :victory
    end

    add_index :champion_matches, [:champion_id, :victory]
    add_index :champion_matches, [:match_id, :victory]
    add_foreign_key :champion_matches, :champions, name: 'fk_rails_champion_matches_champions', on_delete: :cascade
    add_foreign_key :champion_matches, :matches, name: 'fk_rails_champion_matches_matches', on_delete: :cascade
  end
end
