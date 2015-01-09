class VetsController < ApplicationController

  
  def index
    if params[:search]
      @vets = Vet.search(params[:search])
    else
      @vets = Vet.all
      
    end

  end
  
  def show
    begin
      @vet = Vet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to vets_new_path
    end
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


  def create


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
