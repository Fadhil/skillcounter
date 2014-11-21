class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.string :event_name
      t.text :desciption
      t.string :location
      t.string :start_date_time
      t.string :end_date_time
      t.integer :venue_capacity
      t.integer :ticket_quantity
      t.string :event_page_url
      t.string :status

      t.timestamps
    end
  end
end
