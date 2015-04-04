class CreateRawApiTables < ActiveRecord::Migration
  def change
    create_table :champion_api_data do |t|
      t.references :champion, index: true
      t.json       :raw_api_data

      t.timestamps
    end

    create_table :match_api_data do |t|
      t.references :match, index: true
      t.json       :raw_api_data

      t.timestamps
    end

    add_foreign_key :champion_api_data, :champions, name: 'fk_rails_champion_api_data_champions', on_delete: :cascade
    add_foreign_key :match_api_data, :matches, name: 'fk_rails_match_api_data_matches', on_delete: :cascade
  end
end
