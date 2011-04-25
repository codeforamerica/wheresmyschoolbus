class CreateBusses < ActiveRecord::Migration
  def self.up
    create_table :busses do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :busses
  end
end
