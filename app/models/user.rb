class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
    validates :name, presence: true, length: { maximum: 50 }, on: :update
    validates :type, presence: true
  
    
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
