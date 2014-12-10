class EventsController < ApplicationController
    
    
  def index
    if params[:search]
      @events = Event.search(params[:search])
    else
    @events = Event.all
    end

  end

  def new
    gon.eventnames = Event.pluck(:event_name)
    
    #@event = Event.new
    
    @event = current_user.events.build
  end

  def create
    #   event_name = params[:event][:event_name]
    #   description = params[:event][:description]
    #   location = params[:event][:location]
    #   start_date_time = params[:event][:start_date_time]
    #   end_date_time = params[:event][:end_date_time]
    #   event_page_url = params[:event][:event_page_url]
    #   category = params[:event][:category]
    #   speaker_bio = params[:event][:speaker_bio]
    #   schedule = params[:event][:schedule]
    #   poster = params[:event][:poster]
    #   point = params[:event][:point]

    # event = Event.create(event_name: event_name, description: description,
    #         location: location, start_date_time: start_date_time, end_date_time: end_date_time,
    #         event_page_url: event_page_url, category: category, speaker_bio: speaker_bio,
    #         schedule: schedule, poster: poster, status: "pending", point: point)
      @event = current_user.events.build(event_params)



    if @event.save
      #UserMailer.welcome_email(@event).deliver
     
      redirect_to event_path(id: @event.id), success: "Successfully created event"
      
    else

      redirect_to static_pages_home_path, error: "Failed to create event"
      
      #redirent_to new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    
    if @event.update_attributes(event_params)
      redirect_to event_path(id: @event.id), success: "Successfully Updated"
    else
      render :edit
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    
    if @event.destroy
    
      redirect_to events_path, notice: 'Successfully deleted event'
    else
      redirect_to request.referrer, "Cannot destroy user"
      render :index
    end
  end
  
  def event_params
    params.require(:event).permit(:event_name, :description, :location, :start_date_time, :end_date_time, :event_page_url, :status, :point, :category, :speaker_bio, :schedule, :poster)
  end
end
