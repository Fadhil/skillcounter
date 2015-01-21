class PaymentsController < ApplicationController
  authorize_resource

  def new
    @payment = Payment.new
  end


  def create
  end
  

  def index
    @payments = Payment.all
  end


  def show
    @payment = Payment.find(params[:id])
  end


  def edit
    @payment = Payment.find(params[:id])
  end


  def update
    @payment = Payment.find(params[:id])
    
    @payment.fee = params[:payment][:fee]
    @payment.total_in_cents = @payment.fee * 100
    
    if @payment.save
      redirect_to @payment, success: "The fee has been updated."
    else
      redirect_to @payment, error: "Something went wrong. The fee was not updated."
    end
  end


  def delete
  end
  
end
