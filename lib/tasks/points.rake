namespace :points do
  desc "Update vet's points"
  puts "Updated points"
  task update: :environment do
  	  User.all.each do |user|
      	user.expiring_points = user.current_points 
      	user.current_points = 0
      	user.save
      end
  end

end
