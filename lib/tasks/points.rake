namespace :points do
  desc "Update vet's points"
  puts "Updated points"
  task update: :environment do
  	if Date.today.day = 30 && Date.today.mon = 11
  	  User.all.each do |user|
      	user.expiring_points = user.current_points 
      	user.current_points = 0
      	user.save
      end
  	end
  end

end
