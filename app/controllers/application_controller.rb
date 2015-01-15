class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_flash_types :success, :notice, :alert, :error

  
  
  def after_sign_in_path_for(resource)
    if resource.is_admin? 
      root_path
    elsif resource.is_vet? 
      root_path
    elsif resource.is_organizer? 
      root_path
    else
      super
    end
  end

  rescue_from CanCan::AccessDenied do |exception|  
  flash[:error] = "Access denied! You do not have the access rights to the page. Contact the admin for more information."  
  redirect_to root_url  
  end  
 
end


