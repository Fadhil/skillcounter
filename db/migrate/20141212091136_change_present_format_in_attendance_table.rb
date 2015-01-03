class ChangePresentFormatInAttendanceTable < ActiveRecord::Migration
  def up
    change_column :attendances, :present, 'boolean USING CAST(present AS boolean)'
    
  end

  def down
    change_column :attendances, :present, :string
    
  end
end
