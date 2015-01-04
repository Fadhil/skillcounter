class AddPurchasedAtToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :purchased_at, :datetime
  end
end
