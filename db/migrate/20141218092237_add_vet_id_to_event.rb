class AddVetIdToEvent < ActiveRecord::Migration
  
  def change
    add_column :events, :vet_id, :integer
    add_index :events, :vet_id
  end
end
