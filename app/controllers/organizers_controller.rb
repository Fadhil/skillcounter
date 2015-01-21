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
    if (password = params[:organizer][:password]) != nil
      organizer.password = password 
    else
      organizer.password = organizer.password
    end
    if (password_confirmation = params[:organizer][:password_confirmation]) != nil
      organizer.password_confirmation = password_confirmation
    else
      organizer.password_confirmation = organizer.password_confirmation 
    end
  
    if  organizer.save
      redirect_to organizer_path(organizer.id), success: "Successfully Updated"
    else
      redirect_to edit_organizer_path(organizer.id), error: "Failed to update. Please try again."
    end
  end
  
  
  def destroy
    @organizer = Organizer.find(params[:id])
    
    if @organizer.destroy
      redirect_to users_path, notice: 'delete success'
    else
      redirect_to users_path, error: 'Fail'
    end
  end
  
  
  def organizer_params
    params.require(:organizer).permit(:name, :email, :password, :password_confirmation, :address, :contact_number, :avatar, :biodata,)
  end
  
end
