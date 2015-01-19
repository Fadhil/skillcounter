class SessionsController < Devise::SessionsController
    def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        yield resource if block_given?
        
        if current_user_login
            if current_user.is_admin?
                redirect_to static_pages_home_path
            elsif current_user.is_organizer?
                redirect_to manage_event_path
            elsif current_user.is_vet?
                redirect_to vet_event_path
            elsif current_user.is_pending_vet?
                redirect_to transactions_claim_profile_path
            end
        else
            redirect_to new_user_login_session_path
        end
    end 
    
    def destroy
        session.delete(:user_id)
        redirect_to sign_in_path, notice: 'Successfully Signed Out'
        
    end
end