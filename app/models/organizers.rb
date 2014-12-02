class Organizers < User
    
    validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/, message: 'invalid format' }
    validates :contact_number, presence: true, format: { with: /\A[0][1]\d{1}\-\d{7,8}\z/ }
    validates :address, presence: true, length: { maximum: 255 }
end
