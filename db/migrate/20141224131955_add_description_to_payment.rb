class AddDescriptionToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :description, :string
  end
end
