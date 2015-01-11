namespace :points do
  desc "Update vet's points"
  task update: :environment do
  	if Date.today.day == 30 and Date.today.month == 11
  		Rails.logger.info("Updated points")
  	  		User.all.each do |user|
      			user.expiring_points = user.current_points 
      			user.current_points = 0
      			user.save
      		end
  	end
  end

end
