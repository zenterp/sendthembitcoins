class Bridgebase::AccountsController < BridgebaseController
  before_filter :ensure_gateway_account, only: :show

  def show
    @balances = client.get_gateway_balances(@gateway_account['id'])['balances']
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
    @gateway_client ||= Ripple::Gateway::Client.new(
      gateway_api_url: ENV['RIPPLE_GATEWAY_API']
    )
  end
end
