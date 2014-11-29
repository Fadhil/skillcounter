class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
    validates :name, presence: true, length: { maximum: 50 }, on: :update
    # validates :licence_number, presence: true, uniqueness: true
    # validates :ic_number, presence: true, format: { with: /\A\d{6}\-\d{2}\-\d{4}\z/ }
    # validates :contact_number, presence: true, format: { with: /\A[0][1]\d{1}\-\d{7,8}\z/ }
    # validates :current_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    # validates :expiring_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    
    has_and_belongs_to_many :roles
  
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
end
