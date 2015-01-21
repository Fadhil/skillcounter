class OrganizersController < ApplicationController
  authorize_resource

  def index
    @organizer = Organizer.all
  end


  def new
     @organizer = Organizer.new
  end


  def create
    @organizer = Organizer.new(organizer_params)
    
    if @organizer.save
      @organizer.add_role("Organizer")
      @organizer.member_since = Date.today
      Mailer.organizer_welcome_email(@organizer).deliver
      redirect_to root_path, success: "Successfully registered."
    else
      render :new
    end
  end


  def show
      @organizer = Organizer.find(params[:id])
  end
  
  
  def manage_event
      @organizer = Organizer.find(params[:id])
      @previous_events = @organizer.previous_events
      @upcoming_events = @organizer.upcoming_events
  end


  def edit
    @organizer = Organizer.find(params[:id])
  end


  def update
    organizer = Organizer.find(params[:id])

    organizer.name = params[:organizer][:name]
    organizer.email = params[:organizer][:email]
    organizer.address = params[:organizer][:address]
    organizer.contact_number = params[:organizer][:contact_number]

    if (avatar = params[:organizer][:avatar]) != nil
      organizer.avatar = avatar
    end
    if (biodata = params[:organizer][:biodata]) != nil
      organizer.biodata = biodata
    end
    if (password = params[:organizer][:password]) != nil && (password_confirmation = params[:organizer][:password_confirmation]) != nil
      organizer.password = password
      organizer.password_confirmation = password_confirmation
      password_changed = true
    end
  
    if organizer.save
      if password_changed
        redirect_to new_user_login_session_path, success: "Your password has been updated. Please sign in again."
      else
        redirect_to organizer_path(organizer.id), success: "Your details have been successfully updated."
      end
    else
      redirect_to edit_organizer_path(organizer.id), error: "Something went wrong. Your details have not been updated."
    end
  end
  
  
  def destroy
    @organizer = Organizer.find(params[:id])
    
    if @organizer.destroy
      redirect_to users_path, notice: 'The organizer profile has been deleted.'
    else
      redirect_to users_path, error: 'Something went wrong.'
    end
  end
  
  
  def organizer_params
    params.require(:organizer).permit(:name, :email, :password, :password_confirmation, :address, :contact_number, :avatar, :biodata,)
  end
  
end
