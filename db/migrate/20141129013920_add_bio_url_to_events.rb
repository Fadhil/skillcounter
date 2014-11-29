class AddBioUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :bio_url, :string
    add_column :events, :speaker, :string
  end
end
