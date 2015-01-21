class TimelinessValidator < ActiveModel::Validator
	def validate(record)
    time_error_message = ''
    if !record.try(:start_date_time) || !record.try(:end_date_time) 
      record.errors[:base] << "You must specify a start date and end date."
    else
  		if Date.today > record.start_date_time
        record.errors[:base] << "Failed to create event. The start and end dates must be at least 1 day from today."
      elsif record.end_date_time < record.start_date_time
        record.errors[:base] << "End date must be after start date."
      end
    end
	end
end