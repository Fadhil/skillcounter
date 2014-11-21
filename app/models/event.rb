class Event < ActiveRecord::Base
    
    validates :event_id, presence: true
    validates :event_name, presence: true
    validates :desciption, presence: true, length: { maximum: 2500 }
    validates :location, presence: true, length: { maximum: 255 }
    
    belongs_to :organizer
    validates :start_date_time, presence: true, format: {with: "%FT%R", message: 'invalid format' }
    validates :end_date_time, presence: true, format: {with: "%FT%R", message: 'invalid format' }
    # validates :venue_capacity, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    # validates :ticket_quantity, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    validates :event_page_url, presence: true, format: {with: /\A((http)s?(:\/\/)|(www.))\D/}
    validates :status, presence: true
    validates :point, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    validates :category, presence: true
end
