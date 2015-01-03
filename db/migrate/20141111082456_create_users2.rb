class CreateUsers2 < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.timestamps
    end
  end
end
