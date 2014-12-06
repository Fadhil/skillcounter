
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Role.where(name: 'Admin').first_or_create
Role.where(name: 'Vet').first_or_create
Role.where(name: 'Organizer').first_or_create

users = [ [ 'Fadhil', 'fadhil.luqman@gmail.com','Admin'],
          ['Admin','admin@admin.com','Admin'],
          ['Andy', 'andy@gmmail.com', 'Vet']
        ]

users.each do |name, email, role|
  puts name
  puts email
  puts role
    u = User.create(email:email, name: name, password: 'password',
                password_confirmation: 'password', type: role)

    u.add_role(role) 
    puts "Creating User #{name} with role #{role}"
  
end

