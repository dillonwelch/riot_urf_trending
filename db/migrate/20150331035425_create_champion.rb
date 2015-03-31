class CreateChampion < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.integer :riot_id, index: true
      t.string  :name,    index: true
      t.json    :raw_api_data
    end
  end
end
