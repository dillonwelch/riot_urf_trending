class EditIndexesForMatches < ActiveRecord::Migration
  def change
    remove_index :matches, :game_id
    add_index :matches, [:game_id, :region], unique: true
  end
end
