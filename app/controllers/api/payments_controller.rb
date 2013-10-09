class Api::PaymentsController < ApplicationController
  protect_from_forgery :except => [:notification]
  def notification
    binding.pry
    if params['order']['status'] == 'completed'
      if params['order']['button']['custom']
        custom = JSON.parse(params['order']['button']['custom'])
        if (gift = Gift.find(gift_id: custom['gift_id'].to_i))
          gift.update_attributes(funded_at: Time.now)  
        end
      end
    end
    render status: 200
  end
end