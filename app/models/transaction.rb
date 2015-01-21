class Transaction < ActiveRecord::Base
  def purchase(total)
    response = EXPRESS_GATEWAY.purchase(total, express_purchase_options)
    
    if response.success?
      # If purchase was a success, we update the purchased_at field and add status :success
      self.update_attribute(:purchased_at, Time.now) 
      self.update_attribute(:status, :success)
    else
      # Update status to :failure if purchase unsuccessful
      puts response.inspect
      self.update_attribute(:status, :failure)
    end
    response.success?
  end


  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      # you can dump details var if you need more info from buyer
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end


  private

  def express_purchase_options
    {
      :ip => ip_address,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end
  
end
