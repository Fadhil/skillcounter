require 'SkillCounterParams'
require 'roo'
require "spreadsheet"

class AttendancesController < ApplicationController
  respond_to :html, :xls
    
  include SkillCounterParams


  def create
    @event = Event.find(params[:attendance][:attended_event_id])
   
    current_user.attend!(@event)
    redirect_to @event
    
  end
  
  def destroy
    @event = Attendance.find(params[:id]).attended_event
    current_user.minus_point!(@event.point)
    current_user.cancel!(@event)
    redirect_to @event
  end
  
  def present
    @event = Event.find(params[:event_id]) 
    
    if params.has_key?(:finish)
      @event.finish = true
      @event.save
      
      redirect_to @event
    else
      
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

  def import

    @event = Event.find(params[:id])
    
    if @event.update_attributes(event_params)

        file = @event.attendance_list

        spreadsheet = open_spreadsheet(file)
        # spreadsheet = Roo::Excelx.new(file.path)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]


          vet_id = row['attendee_id']

          vet = Vet.find(vet_id)
          vet.add_point!(@event.point)
          vet.attend!(@event)
          vet.save
          # redirect_to event_path(id: @event.id), success: "#{row['attendee_id']}"
            

            
          end
          # @params = params.inspect
          # redirect_to @event

            


            # end
          
        # end
        redirect_to event_path(id: @event.id), success: "Updated attendance list"
    else
        redirect_to event_path(id: @event.id), error: "Fail to update attendance list"
    end


  end

  def download
      # book = Spreadsheet::Workbook.new

      # sheet1 = book.create_worksheet

      # sheet1.row(1).concat ["Attendee_id", "Present"]

      # # we can access the instance variable we set in the controller, just like
      # # in erb template
      # book.write "sample.xls"

      @event = Event.find(params[:id])
      
      @attendance = Attendance.where(attended_event_id: @event.id)

      respond_to do |format|
        format.html
        format.csv { send_data @attendance.to_csv }
        format.xls { send_data @attendance.to_csv(col_sep: "\t") }
      end


  end



  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end



end
