class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_flash_types :success, :notice, :alert, :error
  load_and_authorize_resource
  
  
  def after_sign_in_path_for(resource)
  Rails.logger.info ("testing")
    if resource.is_admin? 
      events_path
    elsif resource.is_vet? 
    events_path
    elsif resource.is_organizer? 
    events_path
  else
    super
     
    end
  
  
  end
 
end


