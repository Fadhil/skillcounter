require 'SkillCounterParams'

class VetsController < ApplicationController

  load_and_authorize_resource
  include SkillCounterParams
  
  def index
    if params[:search]
      @vets = Vet.search(params[:search])
    else
      @vets = Vet.all
      
    end

  end
  
  def show
    begin
      @vet = Vet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to vets_new_path
    end
    @previous_events = @vet.previous_events
    @upcoming_events = @vet.upcoming_events
    @vet.check_point!(@vet.current_points)
  
  end
  
  def vet_event
      @vet = Vet.find(params[:id])
     
  end
  
  def my_events
      @vet = Vet.find(params[:id])
      @previous_events = @vet.previous_events
      @upcoming_events = @vet.upcoming_events
  end

  def new
    @vet = Vet.new
  end

  def create

  end

  ##
  # Claiming a profile comes here first. If a valid unclaimed vet exists,
  # We'll render the paypal checkout button, otherwise we redirect to 
  # the claim page with a notification
  #
  def validate_claim_profile

    @vet = Vet.where(params[:vet]).first # Look for a Vet with the params given

    if @vet && @vet.encrypted_password.blank? # A valid unclaimed vet exists
      fee = Payment.where(description:"Profile claim fee").first

      flash.now[:notice] = "Found your profile. <br/>You will need to make a payment of RM #{fee.fee} before you can claim your profile.".html_safe
      render 'transactions/pay_to_claim'
    else # No such Vet, or previously claimed
      redirect_to vets_new_path, error: "Failed to claim profile. Email or licence may have already been claimed, or is not valid"
    end
  end

  def edit
    @vet = Vet.find(params[:id])
  end

  def update
     @vet = Vet.find(params[:id])
    
    if @vet.update_attributes(vet_params)
      redirect_to vet_path(id: @vet.id), success: "Successfully Updated"
    else
      render :edit
    end
  end

  # not sure what this does
  def claimed_profile
    @vet = current_vet_login
  end

  def redeem_licence
      @vet = Vet.find(params[:id])
      @enough_points = false
      points = @vet.current_points
        
      if points > 80
        @enough_points = true
      else
        @enough_points = false
        redirect_to :back, error: "Not enough points, you can get points by sign up more events"
      end
  end

  def destroy
    @vet = Vet.find(params[:id])
    if @vet.destroy
      redirect_to users_path, notice: 'delete success'
    else
      redirect_to users_path, error: 'Fail'
    end
    
  end

  def express_checkout
    fee = Payment.find_by(description: "Licence renewal fee")
    payment_type = params[:payment_type]
    vet_id = params[:vet_id]

    response = EXPRESS_GATEWAY.setup_purchase(fee.total_in_cents,
      ip: request.remote_ip,
      return_url: renew_licence_new_url(payment_type: payment_type, vet_id: vet_id, fee: fee.total_in_cents), # Pass in the payment type, so that
                                                                   # we know what to do at :create later
      cancel_return_url: renew_licence_cancel_url,
      currency: "USD",
      allow_guest_checkout: true,
      items: [{name: "Fee", description: fee.description, quantity: "1", amount: fee.total_in_cents}]
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def renew_licence_new

      @transaction = Transaction.new(:express_token => params[:token])
      @payment_type = params[:payment_type] # We'll pass this on to :create from the hidden fields in :new view
      @payment_id = params[:payment_id]
      @vet_id = params[:vet_id]
      @fee = params[:fee].to_i

  end

  def renew_licence_create

      @transaction = Transaction.new(transaction_params)
      @transaction.express_token = params[:transaction][:express_token]
      @transaction.ip_address = request.remote_ip
      #@transaction.ip_address = params[:transaction][:ip_address]
      @transaction.payment_type = params[:transaction][:payment_type] # Save the payment type. 
      @fee = params[:transaction][:fee].to_i
      @vet = Vet.find_by(id: params[:transaction][:vet_id])

      if @transaction.save 
        if @transaction.purchase(@fee)
            @vet.current_points -= 80
            @vet.save

            redirect_to vet_path(@vet), success: "Payment was successful. Your licence has been renewed."
        else
            redirect_to vet_path(@vet), error: "Payment failed. Please try again."
        end
      else
          redirect_to vet_path(@vet), error: "Payment failed. Please try again."
      end
  end

  def renew_licence_cancel
  end


  
  def vet_params
    params.require(:vet).permit(:name, :email, :password, :password_confirmation, :ic_number, :licence_number, :current_points, :expiring_points, :avatar, :ip_address, :express_token, :express_payer_id, :purchased_at)
  end
end
