class ChangeFeeInPayment < ActiveRecord::Migration
  def change
  	change_column :payments, :fee, :float
  end
end
