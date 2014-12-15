FactoryGirl.define do
  factory :Organizer, class: Organizer do
    name 'John Doe'
    email 'oraganizer@organizer.com'
    password 'password'
    password_confirmation 'password'
    contact_number '012-2121211'
    address 'address'
  end
end
