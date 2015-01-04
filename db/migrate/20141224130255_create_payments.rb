class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :fee
      t.integer :total_in_cents

      t.timestamps
    end
  end
end
