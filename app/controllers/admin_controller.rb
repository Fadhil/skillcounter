class AdminController < ApplicationController

	def event_index
		if params[:search]
			@events = Event.search(params[:search])
		else
	      	@events = Event.all
		end
	end

	def validate_event
		@event = Event.find(params[:id])
    
    	if @event.update_attribute([:event][:status])  
      		redirect_to event_path(id: @event.id), success: "Successfully Updated"
    	else
      		render :edit
    	end
	end

	def vet_show
		@vet = Vet.find(params[:id])
	end

end
