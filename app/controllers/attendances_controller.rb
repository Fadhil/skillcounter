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
    @event = Event.find(params[:event_id]) 
    
    present_vet_ids = params[:present]
    event_attendances = Attendance.where(attended_event_id: @event.id)
    event_attendances.update_all(present: false)
    event_attendances = event_attendances.where('attendee_id in (?)',present_vet_ids)

    if !event_attendances.empty?
      event_attendances.each do |a|
        a.present = true
        a.save
      end
    end
    @params = params.inspect
    redirect_to @event
  end
end
