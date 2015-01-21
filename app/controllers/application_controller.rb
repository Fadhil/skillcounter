class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    add_flash_types :success, :notice, :alert, :error
    
    # def after_sign_in_path_for(resource)
    #   if resource.is_admin?
    #       redirect_to admin_pending_index_path
    #   elsif resource.is_organizer?
    #       redirect_to manage_event_path
    #   elsif resource.is_vet?
    #       redirect_to vet_event_path
    #   elsif resource.is_pending_vet?
    #       redirect_to transactions_claim_profile_path
    #   end
    # end
    
    rescue_from CanCan::AccessDenied do |exception|  
        flash[:error] = "Access denied! You do not have the access rights to the page. Contact the admin for more information."  
        redirect_to root_url  
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
        flash[:error] = "Something went wrong! Jim is DEAD! I repeat, JIM IS DEAD!"
        redirect_to root_url
    end
end