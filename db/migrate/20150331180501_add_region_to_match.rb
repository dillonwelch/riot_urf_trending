class AddRegionToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :region, :string

    add_index :matches, :region
  end
end
