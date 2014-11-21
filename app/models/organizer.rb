class Organizer < ActiveRecord::Base
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/, message: 'invalid format' }
    validates :contact_number, presence: true, format: { with: /\A[0][1]\d{1}\-\d{7,8}\z/ }
    validates :address, presence: true, length: { maximum: 255 }
    validates :organizerID, presence: true, uniqueness: true
end
