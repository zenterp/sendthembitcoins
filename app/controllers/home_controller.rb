class HomeController < ApplicationController
  layout 'mobile'
  def index
    #if session[:provider] && session[:uid]
      @gifts = Gift.where(recipient_twitter_username: 'stevenzeiler', network: session[:provider]).reject!{|g| g.funded_at.nil? }
    #end
    
    @gifts = [] if @gifts.nil?
  end

end