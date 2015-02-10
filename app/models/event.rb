class Event < ActiveRecord::Base
    # belongs_to :organizer
    # belongs_to :vet
    belongs_to :creator, :class_name => "User"
    has_many :attendances, :foreign_key => "attended_event_id"
    has_many :attendees, :through => :attendances
    scope :upcoming, -> { where("start_date_time >= ?", Date.today).order('start_date_time ASC') }
    scope :upcoming_vet, -> { where("start_date_time >= ? AND status = ?", Date.today, "Live").order('start_date_time ASC') }
    scope :past, -> { where("start_date_time < ?", Date.today).order('start_date_time DESC') }
    scope :pending, -> { where("status = ?", "Pending") }

    has_attached_file :speaker_bio
    has_attached_file :schedule
    has_attached_file :poster, :styles => {:thumb => "100x100"}
    has_attached_file :attendance_list

    validates :event_name, presence: true
    validates :description, presence: true, length: { maximum: 2500 }
    validates :location, presence: true, length: { maximum: 255 }
    validates :start_date_time, presence: true #, format: {with: "%FT%R", message: 'invalid format' }
    validates :end_date_time, presence: true #, format: {with: "%FT%R", message: 'invalid format' }
    validates_with TimelinessValidator, unless: :is_external_event?
    # validates :venue_capacity, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    # validates :ticket_quantity, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    validates :event_page_url, presence: true, format: {with: /\A((http)s?(:\/\/)|(www.))\D/}
    #validates :status, presence: true
    validates :number_participants, presence: true, :numericality => { :other_than => 0 }, unless: :is_external_event?
    validates :point, presence: true, format: {with: /\A[\d]+\Z/ }, numericality: true
    validates :category, presence: true
    validates :speaker, presence: true

    validates_attachment :speaker_bio, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
    validates_attachment :schedule, presence: true, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
    validates_attachment :attendance_list, :content_type => {:content_type => %w(application/zip application/msword application/vnd.ms-office application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet)}

    def self.search(search)
        if search
            where('event_name LIKE ?', "%#{search}%")
        else
            all
        end
    end

    def is_external_event?
        type == 'ExternalEvent'
    end

end
