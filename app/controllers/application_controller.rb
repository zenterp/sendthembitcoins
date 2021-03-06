class ApplicationController < ActionController::Base
  #protect_from_forgery
  after_filter :set_access_control_headers

  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Request-Method'] = '*' 
  end
  
  def index
    @auth = session[:auth] || {}
  end

  def api_docs
  end

  def ripple_txt
    render 'ripple.txt', layout: false
  end
end
