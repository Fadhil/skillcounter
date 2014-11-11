FactoryGirl.define do
  factory :user, class: User do
    name 'John Doe'
    licence_number "valid licence_number"
    ic_number "123456-12-1234"
    contact_number "011-12345678"
    current_points 1234
    expiring_points 1234
    # email "email@email.com"
    # password "password"
    # password_confirmation "password"
  end
end
