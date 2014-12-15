class AddFinishToEvent < ActiveRecord::Migration
  def change
    add_column :events, :finish, :boolean
  end
end
