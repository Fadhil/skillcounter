require 'SkillCounterParams'
require 'roo'
require 'spreadsheet'

class AttendancesController < ApplicationController
  authorize_resource  
  include SkillCounterParams
  respond_to :html, :xls

  def create
    @event = Event.find(params[:attendance][:attended_event_id])
    current_user.attend!(@event)
    redirect_to @event
  end
  
  
  def destroy
    event = Event.find(params[:id])
    attendance = Attendance.find_by(attendee_id: current_user.id, attended_event_id: event.id)
    if attendance.destroy
      redirect_to event_path(event), notice: "You have been removed from the participant list."
    else
      redirect_to event_path(event), error: "Something went wrong. Please try again."
    end
  end
  
  
  # def present
  #   @event = Event.find(params[:event_id]) 
    
  #   if params.has_key?(:finish)
  #     @event.finish = true
  #     @event.save
      
  #     redirect_to @event
  #   else
      
  #     present_vet_ids = params[:present]
  #     event_attendances = Attendance.where(attended_event_id: @event.id)
  #     event_attendances.update_all(present: false)
  #     event_attendances = event_attendances.where('attendee_id in (?)',present_vet_ids)
  
  #     if !event_attendances.empty?
  #       event_attendances.each do |a|
  #         a.present = true
  #         a.save
  #       end
  #     end
  #     @params = params.inspect
  #     redirect_to @event
  #   end
  # end


  def import
    @event = Event.find(params[:id])
      
    if @event.update_attributes(event_params)
      file = @event.attendance_list         
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        vet_id = row['attendee_id']
        present = row['present']
            
        if (present == "P") || (present == "p")
          attendance = Attendance.find_by(attendee_id: vet_id, attended_event_id: @event.id)
          if(attendance.status == nil)
            vet = Vet.find(vet_id)
            vet.add_point!(@event.point)
            vet.save(validate:false)
            attendance.status = "processed"
            attendance.save
          end
        end
      end
      redirect_to event_path(id: @event.id), success: "The attendance list has been successfully updated."
    else
      redirect_to event_path(id: @event.id), error: "Something went wrong. Failed to update attendance list."
    end
  end


  def download
    @event = Event.find(params[:id])
    @attendance = Attendance.where(attended_event_id: @event.id)

    respond_to do |format|
      format.html
      format.csv { send_data @attendance.to_csv }
      format.xls #{ send_data @attendance.to_csv(col_sep: "\t") } #uncomment this if format of the attendance list follows the attendance table format
    end
  end


  def open_spreadsheet(file)
    case File.extname(file.original_filename)
      when '.xls' then Roo::Excel.new(file.url, nil, :ignore)
      when '.xlsx' then Roo::Excelx.new(file.url, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end


  def event_sign_up
    current_user.attendances.build(attended_event_id: params[:id])
    event = Event.find(params[:id])
    event_attendance = Attendance.where(attended_event_id: params[:id])
    
    if event_attendance.size < event.number_participants
      event_attendance.each do |e|
        if e.attendee_id == current_user.id
          redirect_to event_path(event), error: "Uh oh, it seems that you have already been signed up for this event."
          return
        end
      end
      current_user.attend!(event)
      #redirect_to event.event_page_url, :target => "_blank"
      redirect_to event_path(event), notice: "You have successfully signed up for this event!"
    else
      redirect_to event_path(event), error: "The maximum number of participants has been reached."
    end
  end

end
