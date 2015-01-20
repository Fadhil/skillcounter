class AddStatusToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :status, :string
  end
end
