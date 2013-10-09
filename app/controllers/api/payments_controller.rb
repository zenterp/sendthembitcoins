class Api::PaymentsController < ApplicationController
  def notification
    if params['order']['status'] == 'completed'
      custom = JSON.parse(params['order']['button']['custom'])
      if (gift = Gift.find(gift_id: custom['gift_id']))
        gift.update_attributes(funded_at: Time.now)  
      end
      
      render status: 200
    end
  end
end