class ExternalEventsController < ApplicationController
  def new
    @event = ExternalEvent.new
    render '/events/new'
  end

  def create
    @event = ExternalEvent.new(event_params)
    if @event.save
      #UserMailer.welcome_email(@event).deliver

      # Add this custom event to users previous_events
      current_user.attend!(@event)
      redirect_to event_path(id: @event.id), success: "Successfully created event"
    else
      flash.now[:error] =  "Something went wrong. #{@event.errors.full_messages}"
      render 'events/new'    
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private 

  def event_params
    params.require(:external_event).permit(:event_name, :description, :location, :start_date_time, :end_date_time, :event_page_url, :status, :point, :category, :speaker, :speaker_bio, :bio_url, :schedule, :poster, :reason, :attendance_list, :number_participants)
  end
end
