class CreateChampion < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.integer :riot_id
      t.index   :riot_id, unique: true
      t.string  :name
      t.index   :name, unique: true
      t.string  :primary_role, index: true
      t.string  :secondary_role, index: true
      t.json    :raw_api_data

      t.timestamps
    end
  end
end
