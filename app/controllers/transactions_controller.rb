class TransactionsController < ApplicationController

  load_and_authorize_resource

	def express_checkout
		fee = nil
		payment_type = params[:payment_type]
		vet_id = params[:vet_id]

		case payment_type
		when :claim_profile.to_s
			fee = Payment.find_by(description:"Profile claim fee")
		else
			fee = Payment.create(fee: 0, total_in_cents: 0, description: 'zero payment') # We'll next need to sort out payments of type points for organizers.
		end

	  response = EXPRESS_GATEWAY.setup_purchase(fee.total_in_cents,
	    ip: request.remote_ip,
	    return_url: new_transaction_url(payment_type: payment_type, payment_id: fee.id, vet_id: vet_id), # Pass in the payment type, so that
	    																														 # we know what to do at :create later
	    cancel_return_url: cancelled_transactions_url,
	    currency: "USD",
	    allow_guest_checkout: true,
	    items: [{name: "Fee", description: fee.description, quantity: "1", amount: fee.total_in_cents}]
	  )
	  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
	end

	def new
	  @transaction = Transaction.new(:express_token => params[:token])
	  @payment_type = params[:payment_type] # We'll pass this on to :create from the hidden fields in :new view
	  @payment_id = params[:payment_id]
	  @vet = Vet.find(params[:vet_id])

	end

	def cancelled
	  @transaction = Transaction.new(:express_token => params[:token], status: :cancelled)
	  @transaction.save
		redirect_to new_vet_path, error: "Your transaction was cancelled."
	end


	def create

		payment_type = params[:transaction][:payment_type] # From the hidden field in :new

		vet = Vet.find_by_email(params[:email]) # From the hidden field in :new

		fee = Payment.find(params[:payment_id])

		if fee && !vet.nil? # Only continue if we find a valid fee and vet
		  @transaction = Transaction.new(transaction_params)
		  @transaction.ip_address = request.remote_ip
		  @transaction.payment_type = payment_type # Save the payment type. 
		  if @transaction.save 
		    if @transaction.purchase(fee.total_in_cents) # this is where we purchase the transaction. refer to the model method below

		    	if vet.claim                # Claim the vet (set password)
		    		vet.add_role('Vet')
		    	
          			Mailer.send_welcome_email(vet, vet.generate_password).deliver
		        	redirect_to root_path, success: "Successfully claimed profile. An email has been sent to your email with a temporary password and login details. "
		      	else
		      		redirect_to root_path, notice: 'Your payment was successful, but something went wrong with claiming your profile. Please contact the admins.'
		      	end

		    else
		      redirect_to new_vet_path, notice: "Failed to complete your payment."
		    end
		  else
		  	flash.now[:error] = "We were unable to complete your transaction. Please contact the admins."
		    render :action => 'new'
		  end
		 end
	end

	def pay_to_claim

	end

	def successful

	end

	def failed

	end

	def transaction_params
		params.require(:transaction).permit(:ip_address, :express_token, :express_payer_id)
	end

end
