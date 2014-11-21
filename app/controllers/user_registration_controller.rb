class UserRegistrationController < Devise::RegistrationsController
    
    def sign_up_params
      params.require(:user).permit(:name, :licence_number, :ic_number, :contact_number, :current_points, :expiring_points)
    end
 
    def account_update_params
      params.require(:user).permit(:name, :licence_number, :ic_number, :contact_number, :current_points, :expiring_points)
    end
      
end