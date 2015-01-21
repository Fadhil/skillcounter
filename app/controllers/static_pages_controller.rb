class StaticPagesController < ApplicationController
  def home
    if current_user
      if current_user.is_admin?
        redirect_to admin_pending_index_path
      elsif current_user.is_organizer?
        redirect_to manage_event_path(current_user)
      elsif current_user.is_vet?
        redirect_to vet_event_path(current_user)
      elsif current_user.is_pending_vet?
        redirect_to transactions_claim_profile_path
      end
    else
      redirect_to new_user_session_path
    end
  end
  
  def about
  end
end

