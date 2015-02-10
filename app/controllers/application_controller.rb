class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    add_flash_types :success, :notice, :alert, :error
    
    # number of entries per page
    WillPaginate.per_page = 12
    
    def after_sign_in_path_for(resource)
      if resource.is_admin?
          admin_pending_index_path
      elsif resource.is_organizer?
          manage_event_path(current_user)
      elsif resource.is_vet?
          events_path
      elsif resource.is_pending_vet?
          transactions_claim_profile_path
      end
    end
    
    rescue_from CanCan::AccessDenied do |exception|  
        flash[:error] = "Access denied! You do not have the access rights to the page. Contact the admin for more information."  
        redirect_to root_url  
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      flash[:error] = "Something went wong. Please contact the admin for more details."
      redirect_to root_url
    end
end