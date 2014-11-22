class RemoveOrganizerIdFromOrganizers < ActiveRecord::Migration
  def change
    remove_column :organizers, :organizerID, :string
  end
end
