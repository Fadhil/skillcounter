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
  end
  
  def my_events
      @vet = Vet.find(params[:id])
      @previous_events = @vet.previous_events
      @upcoming_events = @vet.upcoming_events
  end

  def new
    @vet = Vet.new
  end

  # def validate_claim_profile
  #   $params = params
  #   # perform checks using ic, licence, and email
  #   if valid, then render paypal partial
  #     render partial: "paypal"
  #   else
  #     redirect_to new_vet_path
  # end

  def create
    #if paypal returns success message
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
        type: "Vet", role: "Vet", member_since: Date.today.to_s)

      if Vet.exists?(email: email)
        # Mailer.send_email(@vet).deliver
      else

      end
    
      if vet.save
        # Mailer.send_welcome_email(@vet).deliver
        redirect_to static_pages_home_path, success: "Successfully claimed profile. An email has been sent to your email with a temporary password and login details. "
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
      redirect_to vet_path(id: @vet.id), sucess: "Successfully Updated"
    else
      render :edit
    end
  end

  def claimed_profile
    @vet = current_vet_login
  end
  
  def vet_params
    params.require(:vet).permit(:name, :email, :password, :password_confirmation, :ic_number, :licence_number, :current_points, :expiring_points, :avatar)
  end
end
