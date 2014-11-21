class AddRoleToUserLogins < ActiveRecord::Migration
  def change
    add_column :user_logins, :role, :string
  end
end
