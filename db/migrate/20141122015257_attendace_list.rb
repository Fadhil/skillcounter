class AttendaceList < ActiveRecord::Migration
    def change
      create_table :attendance_list do |t|
      t.integer :user_id
      t.integer :event_id
      end
      add_index :attendance_list, :user_id
      add_index :attendance_list, :event_id
    end
end
