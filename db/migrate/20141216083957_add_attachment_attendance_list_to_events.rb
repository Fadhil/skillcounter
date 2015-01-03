class AddAttachmentAttendanceListToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :attendance_list
    end
  end

  def self.down
    drop_attached_file :events, :attendance_list
  end
end
