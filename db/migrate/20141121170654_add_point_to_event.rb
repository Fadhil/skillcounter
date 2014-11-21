class AddPointToEvent < ActiveRecord::Migration
  def change
    add_column :events, :point, :integer
  end
end
