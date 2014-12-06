class AddAttachmentSpeakerBioScheduleToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :speaker_bio
      t.attachment :schedule
    end
  end

  def self.down
    drop_attached_file :events, :speaker_bio
    drop_attached_file :events, :schedule
  end
end
