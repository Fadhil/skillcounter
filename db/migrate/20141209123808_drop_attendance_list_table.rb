class DropAttendanceListTable < ActiveRecord::Migration
  def change
    drop_table :attendance_list
  end
end
