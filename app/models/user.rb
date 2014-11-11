class User < ActiveRecord::Base
    validates :name, presence: true, length: { maximum: 50 }
    validates :licence_number, presence: true, uniqueness: true
    validates :ic_number, presence: true, format: { with: /\A\d{6}\-\d{2}\-\d{4}\z/ }
    validates :contact_number, presence: true, format: { with: /\A[0][1]\d{1}\-\d{7,8}\z/ }
    validates :current_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :expiring_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
