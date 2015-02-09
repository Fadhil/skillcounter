namespace :event do
  desc "Daily update of event statuses from live to expired"
  task update_status: :environment do
  	Event.where("end_date_time < ?", Date.today).each do |e|
  		Rails.logger.info("Event status updated")
  		e.status = "Expired"
  		e.save(validate: false)
  	end

  end

end
