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
     @organizer = Organizer.find(params[:id])
    
    if @organizer.update_attributes(organizer_params)
      redirect_to organizer_path(@organizer), success: "Your details have been successfully updated."
    else
      redirect_to organizer_path(@organizer), error: "Something went wrong. Your details have not been updated."
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
