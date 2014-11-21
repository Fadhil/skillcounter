class Event < ActiveRecord::Base
    
    validates :event_id, presence: true
    validates :event_name, presence: true
    validates :desciption, presence: true, length: { maximum: 2500 }
    validates :location, presence: true, length: { maximum: 255 }
    # validates :start_date_time, presence: true, format: {with: "%FT%R", message: 'invalid format' }
    # validates :end_date_time, presence: true, format: {with: "%FT%R", message: 'invalid format' }
    # validates :venue_capacity, presence: true, length: {minimum: 0}, numericality: true
    # validates :ticket_quantity, presence: true, length: {minimum: 0}, numericality: true
    # validates :event_page_url, presence: true #not done yet
    # validates :status, presence: true
end
