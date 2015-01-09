class TransactionsController < ApplicationController

	def express_checkout
		fee = Payment.find_by(description:"Profile claim fee")

	  response = EXPRESS_GATEWAY.setup_purchase(fee.total_in_cents,
	    ip: request.remote_ip,
	    return_url: new_transaction_url,
	    cancel_return_url: cancelled_transactions_url,
	    currency: "USD",
	    allow_guest_checkout: true,
	    items: [{name: "Fee", description: fee.description, quantity: "1", amount: fee.total_in_cents}]
	  )
	  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
	end

	def new
	  @transaction = Transaction.new(:express_token => params[:token])
	end

	def cancelled
	  @transaction = Transaction.new(:express_token => params[:token], status: :cancelled)
	  @transaction.save
		redirect_to new_vet_path, error: "Your transaction was cancelled."
	end


	def create
		#TODO: Move claim_vet here. Should probably make claim_vet a method inside the Vet Model
		#      and just call it here if it's a successful transaction.
		#
		fee = Payment.find_by(description:"Profile claim fee")

	  @transaction = Transaction.new(transaction_params)
	  @transaction.ip_address = request.remote_ip

	  if @transaction.save
	    if @transaction.purchase(fee) # this is where we purchase the transaction. refer to the model method below
	      redirect_to successful_transactions_path 
	    else
	      redirect_to new_vet_path, notice: "Failed to complete your payment."
	    end
	  else
	    render :action => 'new'
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
