class EventsController < ApplicationController
    
    
  def index
    if params[:search]
    @events = Event.search(params[:search])
    else
    @events = Event.all
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
  end

  def show
    # @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    
    if @event.update_attributes(event_params)
      redirect_to event_path(id: @event.id), notice: "Successfully Updated"
    else
      render :edit
    end
  end
  
  
  
  def event_params
    params.require(:event).permit(:name, :email, :password, :password_confirmation)
  end
end
