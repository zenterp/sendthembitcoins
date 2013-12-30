require 'spec_helper'

describe Gift do
  it 'the default factory should be valid' do
    build(:gift).should be_valid
  end

  it 'should require a user id' do
    build(:gift, user_id: nil).should_not be_valid
  end

  it 'should require a bitcoin amount' do
    build(:gift, bitcoin_amount: nil).should_not be_valid
  end
  
  it 'should require an auth provider' do
    build(:gift, auth_provider: nil).should_not be_valid
  end

  it 'does not require an invoice id at first' do
    build(:gift, invoice_id: nil).should be_valid
  end
end

