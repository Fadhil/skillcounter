class ChangeDateFormatInEventTable < ActiveRecord::Migration
  def up
    change_column :events, :start_date_time, 'date USING CAST(start_date_time AS date)'
    change_column :events, :end_date_time, 'date USING CAST(end_date_time AS date)'
  end

  def down
    change_column :events, :start_date_time, :string
    change_column :events, :end_date_time, :string
  end
end
