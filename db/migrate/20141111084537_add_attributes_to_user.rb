class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :licence_number, :string 
    add_index  :users, :licence_number, unique: true
    add_column :users, :ic_number, :string
    add_index  :users, :ic_number, unique: true
    add_column :users, :contact_number, :string
    add_column :users, :current_points, :integer
    add_column :users, :expiring_points, :integer
  end
end
