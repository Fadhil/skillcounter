class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :ip_address
      t.string :express_token
      t.string :express_payer_id

      t.timestamps
    end
  end
end
