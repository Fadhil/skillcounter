class VetsController < ApplicationController

  
  def index
    if params[:search]
      @vets = Vet.search(params[:search])
    else
      @vets = Vet.all
      
    end

  end
  
  def show
    @vet = Vet.find(params[:id])
    @previous_events = @vet.previous_events
      @upcoming_events = @vet.upcoming_events
    @vet.check_point!(@vet.current_points)
  
  end
  
  def vet_event
      @vet = Vet.find(params[:id])
     
  end
  
  def my_events
      @vet = Vet.find(params[:id])
      @previous_events = @vet.previous_events
      @upcoming_events = @vet.upcoming_events
  end

  def new
    @vet = Vet.new
  end

  ##
  # Claiming a profile comes here first. If a valid unclaimed vet exists,
  # We'll render the paypal checkout button, otherwise we redirect to 
  # the claim page with a notification
  #
  def validate_claim_profile

    @vet = Vet.where(params[:vet]).first # Look for a Vet with the params given

    if @vet && @vet.encrypted_password.blank? # A valid unclaimed vet exists
      flash.now[:notice] = "Found your profile. <br/>You will need to make a payment of RM XX before you can claim your profile.".html_safe
      render 'transactions/pay_to_claim'
    else # No such Vet, or previously claimed
      redirect_to vets_new_path, error: "Failed to claim profile. Email or licence may have already been claimed, or is not valid"
    end
  end

  # Vets should have already been created at this point by 
  # the admin via upload_vets. 
  # Now we just need to make sure that the IC and License Numbers
  # match those that we have in our database. 
  #
  # If a match is found, we'll update the vet's password and confirmation
  # with the generated_password we created, and email him the details
  #
  def create
    #if paypal returns success message

      generated_password = email[0..2] + ic[0..2] + licence[0..2]
      @vet = Vet.where(params[:vet]).first

      if @vet && @vet.encrypted_password.blank? # Make sure @vet has not been claimed before. Unclaimed @vets don't have passwords.
        @vet.password = generated_password
        @vet.password_confirmation = generated_password

        if @vet.save
          @vet.add_role("Vet")

          Mailer.send_welcome_email(@vet, generated_password).deliver
          redirect_to root_path, success: "Successfully claimed profile. An email has been sent to your email with a temporary password and login details. "
        else
          redirect_to vets_new_path, error: 'Unable to claim your profile. Please contact the admins'
        end
      else
        redirect_to vets_new_path, error: "Failed to claim profile. Email or licence may have already been claimed, or is not valid"
      end
  end

  def edit
    @vet = Vet.find(params[:id])
  end

  def update
     @vet = Vet.find(params[:id])
    
    if @vet.update_attributes(vet_params)
      redirect_to vet_path(id: @vet.id), success: "Successfully Updated"
    else
      render :edit
    end
  end

  def claimed_profile
    @vet = current_vet_login
  end
  
  def redeem_licence
   @vet = Vet.find(params[:id])
    points = @vet.current_points
    
    if points > 80
     
       flash[:success] = "You had redeem your licence"
     
    else
      
      flash[:error] = "Not enough points, you can get points by sign up more events"
       
    end
    
    #redirect_to vet_path(current_user)
    redirect_to :back
    
  end

  
  
  def destroy
    @vet = Vet.find(params[:id])
    if @vet.destroy
      redirect_to users_path, notice: 'delete success'
    else
      redirect_to users_path, error: 'Fail'
    end
    
  end
  
  def vet_params
    params.require(:vet).permit(:name, :email, :password, :password_confirmation, :ic_number, :licence_number, :current_points, :expiring_points, :avatar, :ip_address, :express_token, :express_payer_id, :purchased_at)
  end
end
