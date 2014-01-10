class Bridgebase::AccountsController < BridgebaseController
  before_filter :ensure_gateway_account, only: :show

  def show
    @balances = client.get_gateway_balances(@user_id)
  end

  def logout
    reset_session
    session[:coinbase] = nil
    redirect_to '/bridgebase'
  end

  def ensure_gateway_account
    @user_id = session[:coinbase][:uid]
    @gateway_account   = client.get_gateway_account(@user_id)
    @gateway_account ||= client.create_gateway_account(@user_id)
  end

private

  def client
    @gateway_client ||= ripple_gateway_client
  end
end
