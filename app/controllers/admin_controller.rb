require 'SkillCounterParams'

class AdminController < ApplicationController
	
	include SkillCounterParams


	def event_index
		if params[:search]
			@events = Event.search(params[:search])
		else
	      	@events = Event.all
		end
	end

	def validate_event
		@event = Event.find(params[:id])


		def update
			@event = Event.find(params[:id])

		    if @event.update_attributes(event_params)
  				redirect_to admin_event_index_path, success: "Successfully Updated"
			else
	  			redirect_to admin_event_index_path, success: "Fail to update event status"
			end
		end
	end




	def vet_show
		@vet = Vet.find(params[:id])
	end

end