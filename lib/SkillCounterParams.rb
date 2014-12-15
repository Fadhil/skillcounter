module SkillCounterParams
  
  def event_params
  	if params.has_key?(:event)
    	params.require(:event).permit(:event_name, :description, :location, :start_date_time, :end_date_time, :event_page_url, :status, :point, :category, :speaker_bio, :schedule, :poster, :reason)
    end	
  end
  
end
