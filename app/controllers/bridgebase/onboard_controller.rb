class Bridgebase::OnboardController < BridgebaseController 
  skip_before_filter :verify_coinbase_session
    
  def home
  end
end
