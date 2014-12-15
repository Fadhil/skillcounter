class AddAttachmentAvatarBiodataToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avatar
      t.attachment :biodata
    end
  end

  def self.down
    drop_attached_file :users, :avatar
    drop_attached_file :users, :biodata
  end
end
