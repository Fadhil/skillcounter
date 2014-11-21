class OrganizerRegistrationsController < Devise::RegistrationsController
    

    def sign_up_params
      params.require(:organizers).permit(:name, :address, :contact_number, :organizer_id, :events)
    end
 
    def account_update_params
      params.require(:organizers).permit(:name, :address, :contact_number, :organizer_id, :events)
    end
      
end