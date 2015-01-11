class PaymentsController < ApplicationController

  load_and_authorize_resource

  def new
    @payment = Payment.new
  end

  def create
    
    fee = [:params][:fee]
    total_in_cents = fee * 100

    payment = Payment.create(fee: fee, total_in_cents: total_in_cents)

    payment.save

  end

  def edit
  end

  def update
  end

  def delete
  end
end
