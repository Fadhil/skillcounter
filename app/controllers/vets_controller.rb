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

  def validate_claim_profile

    email = params[:vet][:email]
    ic = params[:vet][:ic_number]
    licence = params[:vet][:licence_number]
    
    generated_password = email[0..2] + ic[0..2] + licence[0..2]

    vet = Vet.create(
      name: "PENDING ACCOUNT NAME", email: email, ic_number: ic,
      licence_number: licence, contact_number: "012-1234567",
      current_points: 0, expiring_points: 0, 
      # password:generated_password, password_confirmation: generated_password)
      # changed back to this "password" due to unconfigured sendgrid accout
      password: "password", password_confirmation: "password",
      type: "Vet", role: "Vet")#, member_since: Date.today.to_s)

    if Vet.exists?(email: email)
      # Mailer.send_email(@vet).deliver
    else

    end
  
    if vet.save
      vet.add_role("Vet")

      # Mailer.send_welcome_email(@vet).deliver
      redirect_to @vet.claim_profile(vet_path(@vet))
    else
      redirect_to vets_new_path, error: "Failed to create profile. Email or licence number may have been used for another accout"
    end


  end

  def create
    #if paypal returns success message


    # valid = claim_profile

      email = params[:vet][:email]
      ic = params[:vet][:ic_number]
      licence = params[:vet][:licence_number]
      
      generated_password = email[0..2] + ic[0..2] + licence[0..2]

      @vet = Vet.create(
        name: "PENDING ACCOUNT NAME", email: email, ic_number: ic,
        licence_number: licence, contact_number: "012-1234567",
        current_points: 0, expiring_points: 0, 
        # password:generated_password, password_confirmation: generated_password)
        # changed back to this "password" due to unconfigured sendgrid accout
        password: "password", password_confirmation: "password",
        type: "Vet", role: "Vet")#, member_since: Date.today.to_s)

      if Vet.exists?(email: email)
        # Mailer.send_email(@vet).deliver
      else

      end
    
      if @vet.save
        @vet.add_role("Vet")

        # Mailer.send_welcome_email(@vet).deliver
        
        redirect_to @vet.claim_profile(vet_path(@vet))
      else
        redirect_to vets_new_path, error: "Failed to create profile. Email or licence number may have been used for another accout"
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

  
  def vet_params
    params.require(:vet).permit(:name, :email, :password, :password_confirmation, :ic_number, :licence_number, :current_points, :expiring_points, :avatar, :ip_address, :express_token, :express_payer_id, :purchased_at)
  end
end
