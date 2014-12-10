class AddMemberSinceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :member_since, :string
  end
end
