class Bridgebase::AccountsController < BridgebaseController
  def show
  end 

  def logout
    reset_session
    session[:coinbase] = nil
    redirect_to '/bridgebase'
  end
end
