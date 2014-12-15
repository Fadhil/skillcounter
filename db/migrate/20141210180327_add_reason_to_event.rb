class AddReasonToEvent < ActiveRecord::Migration
  def change
    add_column :events, :reason, :string
  end
end
