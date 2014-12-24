class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :id_address, :string
    add_column :users, :express_token, :string
    add_column :users, :express_payer_id, :string
  end
end
