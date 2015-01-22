class Ability
  include CanCan::Ability

    # def initialize(user)
    # user ||= User.new
    # #user = (user.nil?)?User.new:user
    # #if user is new use user.new else use user
    
    # if user.has_role?('Admin')
    # can :manage, :all
    # elsif user.has_role?('Developer')
    # can :manage, :all
    # else
    # cannot :manage, :all
    
    # cannot :index, User
    # can [:show, :edit, :update], User, id: user.id
    
       
      
    # end
    
  def initialize(user)
  # Define abilities for the passed in user here. For example:
  #
    user ||= User.new # guest user (not logged in)
    cannot :manage, :all
    can [:new, :create], Organizer
    

    if user.is_admin?
      can :manage, :all
      can [:edit, :update], Admin, id: user.id 
      cannot [:edit, :update], Organizer
      cannot [:edit, :update], Vet
    elsif user.is_organizer?
      can [:index, :new, :create, :show, :edit, :update, :purchase_points, :upload_attendance, :express_checkout, :event_payment_new, :event_payment_create, :event_payment_cancel], Event
      can [:index, :show, :manage_event], Organizer
      can [:edit, :update], Organizer, id: user.id
      can :manage, Attendance
      can :manage, ExternalEvent
      can [:index, :show, :redeem_licence, :express_checkout, :renew_licence_new, :renew_licence_create, :renew_licence_cancel], Vet
      can [:vet_event, :my_events, :edit, :update], Vet, id: user.id
    elsif user.is_vet?
      can [:index, :show], Event
      can [:show], Organizer
      can [:create, :destroy, :event_sign_up], Attendance
      can :manage, ExternalEvent
      can [:index, :show], Vet
      can [:redeem_licence, :express_checkout, :renew_licence_new, :renew_licence_create, :renew_licence_cancel], Vet
      can [:vet_event, :my_events, :edit, :update], Vet, id: user.id
    elsif user.is_pending_vet?
      can [:validate_claim_profile], Vet
      can :manage, Transaction
    end
  end

  #def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  #end
end
