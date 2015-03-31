class CreateMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :game_id, index: true
      t.json    :raw_api_data
      t.json  :champion_data
    end
  end
end
