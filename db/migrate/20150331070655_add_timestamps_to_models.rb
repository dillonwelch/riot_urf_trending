class AddTimestampsToModels < ActiveRecord::Migration
  def change
    add_column :matches, :start_time, :bigint
    add_column :matches, :duration, :bigint

    add_timestamps :matches
    add_timestamps :champions
    add_timestamps :champion_matches
  end
end
