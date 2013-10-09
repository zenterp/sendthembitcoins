class Api::PaymentsController < ApplicationController
  protect_from_forgery :except => [:notification]
  def notification
    if params['order']['status'] == 'completed'
      custom = JSON.parse(params['order']['custom'])
      if (gift = Gift.find(custom['gift_id'].to_i))
        gift.update_attributes(funded_at: Time.now)  
      end
    end
    render status: 200
  end
end