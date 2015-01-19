class OrganizersController < ApplicationController

  load_and_authorize_resource

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
     
      redirect_to root_path), success: "Successfully registered."
    else

      render :new
      #redirent_to new
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
     @organizer = Organizer.find(params[:id])
    
    if  @organizer.update_attributes(organizer_params)
      redirect_to organizer_path(id:  @organizer.id), success: "Successfully Updated"
    else
      render :edit
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
