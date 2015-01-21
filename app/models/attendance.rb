class Attendance < ActiveRecord::Base
    belongs_to :attendee, class_name: "User"
    belongs_to :attended_event, class_name: "Event"
    
    validates :attendee_id, presence: true
  	validates :attended_event_id, presence: true

  	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
	    csv << column_names
	    all.each do |attendance|
	      csv << attendance.attributes.values_at(*column_names)
	    end
	  end
	end
    
end
