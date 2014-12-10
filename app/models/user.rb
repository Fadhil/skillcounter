class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
    validates :name, presence: true, length: { maximum: 50 }, on: :update
    validates :type, presence: true
  
    
    has_and_belongs_to_many :roles
    has_many :events, :foreign_key => :organizer_id
    has_many :attendances, :foreign_key => :attendee_id
    has_many :attended_events, :through => :attendances
     
  
  def is_admin?
    self.roles.include?(Role.find_by_name('Admin'))
  end
  
  def is_organizer?
    self.roles.include?(Role.find_by_name('Organizer'))
  end
  
  def is_vet?
    self.roles.include?(Role.find_by_name('Vet'))
  end
  
  def is_role?(role_name)
    self.roles.include?(Role.find_by_name(role_name))
  end
  
  def add_role(role_name)
    role_to_assign = Role.find_by_name(role_name)
    if role_to_assign
      if !self.roles.include?(Role.find_by_name(role_name))
        self.roles.push(role_to_assign)
      end
    end
  end
  
  def remove_role(role_name)
    role_to_remove = Role.find_by_name(role_name)
    if role_to_remove
      if !self.roles.include?(Role.find_by_name(role_name))
        self.roles.push(role_to_remove)
      end
    end
  end
  
  def self.has_role
    joins(:roles).where("roles.name = 'Admin'") 
  end
  
  def attending?(event)
    event.attendees.include?(self)
  end

  def attend!(event)
    self.attendances.create!(attended_event_id: event.id)
  end

  def cancel!(event)
    self.attendances.find_by(attended_event_id: event.id).destroy
  end
  
  def upcoming_events
    self.attended_events.upcoming
  end

  def previous_events
    self.attended_events.past
  end
  
  
end
