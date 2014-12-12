class AttendancesController < ApplicationController
    
    def create
    @event = Event.find(params[:attendance][:attended_event_id])
    current_user.attend!(@event)
    redirect_to @event
  end
  
  def destroy
    @event = Attendance.find(params[:id]).attended_event
    current_user.cancel!(@event)
    redirect_to @event
  end
  
  def present
    Attendance.update_all(["present=?", 'true'], :id => params[:attendee_ids])
  end
end
