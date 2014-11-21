class RemoveEmailFromOrganizers < ActiveRecord::Migration
  def change
    remove_column :organizers, :email, :string
  end
end
