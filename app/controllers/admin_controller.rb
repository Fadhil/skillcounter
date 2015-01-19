require 'SkillCounterParams'
require 'roo'

class AdminController < ApplicationController

	load_and_authorize_resource
	include SkillCounterParams


  def new
    @admin = Admin.new
  end



	def event_index
		if params[:search]
			@events = Event.search(params[:search])
		else
	      	@events = Event.all
		end
	end

	def pending_index
		@event = Event.where(status:"Pending")
	end

	def validate_event
		@event = Event.find(params[:id])


		def update
			@event = Event.find(params[:id])

		    if @event.update_attributes(event_params)
  				redirect_to admin_event_index_path, success: "Successfully Updated"
			else
	  			redirect_to admin_event_index_path, error: "Fail to update event status. #{@event.errors.full_messages}"
			end
		end

	end




	def vet_show
		@vet = Vet.find(params[:id])
	end

	def upload_vets


	end

	##
	# Receives uploaded file in params[:vet_list]
	# If file is a CSV, we load it up with Roo and 
	# go through each line to add a Vet user with those 
	# details
	#
	# Vet CSV should look like this:
	#
	# Name | Email 				| License   | IC Number 		| Contact Number
	# Hafiz| hafiz@gmail.com 	|	a12345	| 900928-12-2221	|	012-23242555
	# Hafiq| hafiq@gmail.com 	|	a12346	| 900928-12-2223	|	012-23242556
	#
	# There might be a limit to 999 rows for Roo. Some one will need to 
	# Check this out at some point
	#
	def save_uploaded_vets

		uploaded_file = params[:vet_list]

			if uploaded_file && uploaded_file.original_filename =~ /\.csv$/

				sheet = Roo::CSV.new(uploaded_file.path)
				
				vets_count = 0
				# We're assuming the first row is a header
				( (sheet.first_row + 1) .. sheet.last_row ).each do |rownum|
					row = sheet.row(rownum)
					# Only create vet if that email hasn't been used yet
					if Vet.where(email: row[VetCsvFields::EMAIL]).blank?
						vet = Vet.new(name: row[VetCsvFields::NAME], 
													email: row[VetCsvFields::EMAIL],
													licence_number: row[VetCsvFields::LICENSE],
													ic_number: row[VetCsvFields::IC], 
													contact_number: row[VetCsvFields::CONTACT]  
													)
						vet.add_role("Pending_vet")
						vet.member_since = Date.today
						vet.save(validate: false)
						vets_count += 1
					end
				end

				redirect_to admin_upload_vets_path, notice: "Uploaded and created #{vets_count} vets"

			else
				redirect_to admin_upload_vets_path, notice: "You must upload a CSV file."
			end

	end


	# def event.search(search)
 #   	if search
 #   		find(:all, :conditions => ['event_name LIKE ?', "%#{search}%"])
 #   	else
    		
 #   	end
 #   end

end
