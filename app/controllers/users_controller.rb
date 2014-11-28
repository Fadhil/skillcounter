class UsersController < ApplicationController
  
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def validate_claim_profile
    $params = params
    # perform checks using ic, licence, and email
    # if valid, then render paypal partial
      render partial: "paypal"
    # else
      redirect_to new_user_path
  end

  def create
    #if paypal returns success message
      email = $params[:user][:email]
      ic = $params[:user][:ic_number]
      licence = $params[:user][:licence_number]
      
      generated_password = email[0..2] + ic[0..2] + licence[0..2]
      UserLogin.create(email: email, password: generated_password, password_confirmation: generated_password, role: "user")
      User.create(
        name: "PENDING ACCOUNT NAME", email: email, ic_number: ic,
        licence_number: licence, contact_number: "012-1234567",
        current_points: 0, expiring_points: 0)
      
      if User.exists?(email: email)
        # send email containing generated password
        redirect_to users_claimed_profile_path
      else
        # some error message then redirect
      end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
     @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      redirect_to user_path(id: @user.id), notice: "Successfully Updated"
    else
      render :edit
    end
  end

  def claimed_profile
    @user = current_user_login
  end
  
  def user_params
    params.require(:user).permit(:name, :ic_number, :contact_number, :email, :licence_number, :current_points, :expiring_points)
  end
end
