class Event < ActiveRecord::Base
    
    belongs_to :organizer
    belongs_to :creator, :class_name => "User"
    has_many :attendances, :foreign_key => "attended_event_id"
    has_many :attendees, :through => :attendances

    has_attached_file :speaker_bio
    has_attached_file :schedule
    has_attached_file :poster, :styles => {:thumb => "100x100"}

    validates :event_name, presence: true
    validates :description, presence: true, length: { maximum: 2500 }
    validates :location, presence: true, length: { maximum: 255 }
    
    
    validates :start_date_time, presence: true #, format: {with: "%FT%R", message: 'invalid format' }
    validates :end_date_time, presence: true #, format: {with: "%FT%R", message: 'invalid format' }
    # validates :venue_capacity, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    # validates :ticket_quantity, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    validates :event_page_url, presence: true, format: {with: /\A((http)s?(:\/\/)|(www.))\D/}
    #validates :status, presence: true
    validates :point, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    validates :category, presence: true

    validates_attachment :speaker_bio, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
    validates_attachment :schedule, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}

    
    def self.search(search)
        if search
        find(:all, :conditions => ['event_name LIKE ?', "%#{search}%"])
        else
        find(:all)
        end
    end
end
