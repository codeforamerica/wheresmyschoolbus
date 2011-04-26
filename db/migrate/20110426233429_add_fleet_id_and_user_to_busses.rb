class AddFleetIdAndUserToBusses < ActiveRecord::Migration
  def self.up
    add_column :busses, :fleet_id, :string
    add_column :busses, :user_id, :integer
  end

  def self.down
    remove_column :busses, :fleet_id
    remove_column :busses, :user_id
  end
end
