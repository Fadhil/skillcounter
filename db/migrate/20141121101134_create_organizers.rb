class CreateOrganizers < ActiveRecord::Migration
  def change
    create_table :organizers do |t|
      t.string :name
      t.string :contact_number
      t.string :email
      t.string :address
      t.integer :organizerID

      t.timestamps
    end
  end
end
