class AddStudentId < ActiveRecord::Migration
  def self.up
    add_column :users, :student_ids, :string
  end

  def self.down
    remove_column :users, :student_ids
  end
end
