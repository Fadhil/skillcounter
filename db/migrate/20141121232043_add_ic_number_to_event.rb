class AddIcNumberToEvent < ActiveRecord::Migration
  def change
    add_column :events, :ic_number, :integer
    add_index :events, :ic_number
  end
end
