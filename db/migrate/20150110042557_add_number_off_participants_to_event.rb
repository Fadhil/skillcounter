class AddNumberOffParticipantsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :number_participants, :integer
  end
end
