class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    user = {}
    session[:providers] ||= []
    session[:providers].each do |provider|
      user["#{provider[:name]}_uid".to_sym] = provider[:uid]
      user["#{provider[:name]}_username".to_sym] = provider[:username]
    end

    coinbase = session[:providers].select{|p| p[:name] == 'coinbase'}[0]
    if coinbase.present?
      user[:receive_address] = Oauth::CoinbaseOauth.get_receive_address(coinbase[:credentials]['token'])
    end

    return user
  end
end
