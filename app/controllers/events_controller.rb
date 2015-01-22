require 'SkillCounterParams'

class EventsController < ApplicationController
  authorize_resource
  include SkillCounterParams


  def index
    if params[:search]
      @events = Event.search(params[:search])
    else
      if current_user.is_vet?
        @events = Event.upcoming_vet.paginate(page: params[:upcoming]).per_page(12)
      else
        @events = Event.upcoming.paginate(page: params[:upcoming]).per_page(12)
      end
    # @events_upcoming = Event.upcoming
    # @events_past = Event.past
    end
  end


  def new
    gon.eventnames = Event.pluck(:event_name)
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
    @event.status = "Pending"

    if @event.save
      #UserMailer.welcome_email(@event).deliver
      redirect_to event_path(id: @event.id), success: "Successfully created event"
    else
      flash.now[:error] =  "Something went wrong. #{@event.errors.full_messages}"
      render :new
    end
  end


  def show
    @event = Event.find(params[:id])
  end


  def edit
    @event = Event.find(params[:id])
  end


  def update
    event = Event.find(params[:id])

    event.event_name = params[:event][:event_name]
    event.description = params[:event][:description]
    event.location = params[:event][:location]
    event.start_date_time = params[:event][:start_date_time]
    event.end_date_time = params[:event][:end_date_time]
    event.event_page_url = params[:event][:event_page_url]
    event.category = params[:event][:category]
    event.poster = params[:event][:poster]
    event.point = params[:event][:point]
    event.status = "Pending"
    
    if (speaker_bio = params[:event][:speaker_bio]) != nil
      event.speaker_bio = speaker_bio
    end

    if (schedule = params[:event][:schedule]) != nil
      event.schedule = schedule
    end
    
    if @event.save
      redirect_to event_path(id: @event.id), success: "The event details have been successfully updated."
    else
      redirect_to event_path(id: @event.id), error: "Something went wrong. The event details have not been updated."
    end
  end
  
  
  def approve_event
    event = Event.find(params[:id])
    event.status = "Approved"
    if event.save
      redirect_to event, success: "The event has been approved."
    else
      redirect_to event, error: "Something went wrong. The event was not approved."
    end
  end
  
  
  def destroy
    @event = Event.find(params[:id])
    
    if @event.destroy
      redirect_to events_path, notice: 'The event has been successfully deleted.'
    else
      redirect_to :back, "Something went wrong. The event was not deleted."
      render :index
    end
  end 


  def purchase_points
    @event = Event.find(params[:id])
  end


  def upload_attendance
    @event = Event.find(params[:id])
  end


  def express_checkout
    fee = Payment.find_by(description: "Event points fee")
    payment_type = params[:payment_type]
    event_id = params[:event_id]
    organizer_id = params[:organizer_id]

    fee.fee = fee.fee * Event.find_by(id: event_id).number_participants
    fee.total_in_cents = fee.fee * 100

    response = EXPRESS_GATEWAY.setup_purchase(fee.total_in_cents,
      ip: request.remote_ip,
      return_url: event_payment_new_url(payment_type: payment_type, event_id: event_id, organizer_id: organizer_id, fee: fee.total_in_cents), # Pass in the payment type, so that
                                                                   # we know what to do at :create later
      cancel_return_url: event_payment_cancel_url,
      currency: "USD",
      allow_guest_checkout: true,
      items: [{name: "Fee", description: fee.description, quantity: "1", amount: fee.total_in_cents}]
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end


  def event_payment_new
      @transaction = Transaction.new(:express_token => params[:token])
      @payment_type = params[:payment_type] # We'll pass this on to :create from the hidden fields in :new view
      @payment_id = params[:payment_id]
      @organizer = Organizer.find(params[:organizer_id])
      @event = Event.find(params[:event_id])
      @fee = params[:fee].to_i
  end


  def event_payment_create 
      @transaction = Transaction.new(transaction_params)
      @transaction.express_token = params[:transaction][:express_token]
      @transaction.ip_address = request.remote_ip
      #@transaction.ip_address = params[:transaction][:ip_address]
      @transaction.payment_type = params[:transaction][:payment_type] # Save the payment type. 
      @fee = params[:transaction][:fee].to_i
      @event = Event.find_by(id: params[:transaction][:event_id])

      if @transaction.save 
        if @transaction.purchase(@fee)
            @event.status = "Live"
            if @event.save
              redirect_to events_path(@event), success: "Payment was successful. Your event is now live!"
            else
              redirect_to events_path(@event), error: "Something went wrong. Your event status has not been updated."
            end
        else
            redirect_to events_path(@event), error: "Payment failed. Please try again."
        end
      else
        redirect_to events_path(@event), error: "Payment failed. Please try again."
      end
  end


  def event_payment_cancel
    @transaction = Transaction.new(:express_token => params[:token], status: :cancelled)
    @transaction.save
    redirect_to event_path(@event), error: "Your transaction was cancelled."
  end


  def event_params
    params.require(:event).permit(:event_name, :description, :location, :start_date_time, :end_date_time, :event_page_url, :status, :point, :category, :speaker, :speaker_bio, :bio_url, :schedule, :poster, :reason, :attendance_list, :number_participants)
  end
end
