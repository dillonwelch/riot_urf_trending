class CreateMatch < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :game_id
      t.index   :game_id, unique: true
      t.string  :region, index: true
      t.bigint  :start_time
      t.bigint  :duration
      t.json    :champion_data
      t.json    :raw_api_data

      t.timestamps
    end
  end
end
