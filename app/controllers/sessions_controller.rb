class SessionsController < Devise::SessionsController
    def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        yield resource if block_given?
        
        if current_user_login
            redirect_to static_pages_home_path
        else
            redirect_to new_user_login_session_path
        end
    end 
    
    def destroy
        session.delete(:user_id)
        redirect_to sign_in_path, notice: 'Successfully Signed Out'
        
    end
end