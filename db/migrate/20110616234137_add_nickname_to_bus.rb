class AddNicknameToBus < ActiveRecord::Migration
  def self.up
    add_column :busses, :nickname, :string
  end

  def self.down
    remove_column :busses, :nickname
  end
end
