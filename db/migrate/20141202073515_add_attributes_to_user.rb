class AddAttributesToUser < ActiveRecord::Migration
  def change
    # vet attributes
      add_column :users, :licence_number, :string
      add_column :users, :ic_number, :string
      add_column :users, :contact_number, :string
      add_column :users, :current_points, :int
      add_column :users, :expiring_points, :int
      
    # organizer attributes
      add_column :users, :address, :string

  end
end
