class OrganizersController < ApplicationController
  def index
    @organizer = Organizer.all
  end

  def new
     @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(organizer_params)
  end

  def show
      @organizer = Organizer.find(params[:id])
  end

  def edit
    @organizer = Organizer.find(params[:id])
  end

  def update
     @organizer = Organizer.find(params[:id])
    
    if  @organizer.update_attributes(organizer_params)
      redirect_to user_path(id:  @organizer.id), notice: "Successfully Updated"
    else
      render :edit
    end
  end
  
  def organizer_params
    params.require(:organizer).permit(:name, :email, :address, :contact_number)
  end
end
