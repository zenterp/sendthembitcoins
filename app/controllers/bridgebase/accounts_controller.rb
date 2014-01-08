class Bridgebase::AccountsController < BridgebaseController
  def show
  end 

  def logout
    session[:coinbase] = nil
    redirect_to '/bridgebase'
  end
end
