FactoryGirl.define do
  factory :vet, class: Vet do
    name 'John Doe'
    email 'vet@vet.com'
    password 'password'
    password_confirmation 'password'
    licence_number '123'
    ic_number '123456-12-1234'
    contact_number '012-1212121'
    current_points '123'
    expiring_points '123'

  end
end
