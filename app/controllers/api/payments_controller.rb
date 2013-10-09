class Api::PaymentsController < ApplicationController
  protect_from_forgery :except => [:notification]
  def notification
    logger.debug params['order']
    if params['order']['status'] == 'completed'
      logger.debug params['order']['button']
      if params['order']['button']['custom']
        logger.debug params['order']['button']['custom']
        logger.debug JSON.parse(params['order']['button']['custom'])
        custom = JSON.parse(params['order']['button']['custom'])
        if (gift = Gift.find(gift_id: custom['gift_id'].to_i))
          gift.update_attributes(funded_at: Time.now)  
        end
      end
    end
    render status: 200
  end
end