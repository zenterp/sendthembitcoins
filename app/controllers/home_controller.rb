class HomeController < ApplicationController
  layout 'mobile'
  def index
    #if session[:provider] && session[:uid]
      @gifts = Gift.where(recipient_twitter_username: 'stevenzeiler', network: session[:provider])
    #end
    
    @gifts = [] if @gifts.nil?
  end

end