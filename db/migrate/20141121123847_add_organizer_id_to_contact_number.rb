class AddOrganizerIdToContactNumber < ActiveRecord::Migration
  def change
    add_column :contact_numbers, :organizer_id, :integer
    add_index :contact_numbers, :organizer_id
  end
end
