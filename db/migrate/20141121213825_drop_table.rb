class DropTable < ActiveRecord::Migration
  def change
    drop_table :logins
  end
end
