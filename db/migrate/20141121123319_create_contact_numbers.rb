class CreateContactNumbers < ActiveRecord::Migration
  def change
    create_table :contact_numbers do |t|

      t.timestamps
    end
  end
end
