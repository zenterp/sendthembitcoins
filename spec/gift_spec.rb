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

  describe 'lower limit for gift in bitcoins' do
    let(:limit) { 0.001 }

    it 'should set a lower limit of 0.001 for bitcoin amount' do
      build(:gift, bitcoin_amount: limit).should be_valid
    end

    it 'should reject gifts less than 0.001 bitcoins' do
      build(:gift, bitcoin_amount: (limit - 0.0001)).should_not be_valid
    end
  end

  describe 'finding gifts for a given user' do
    let(:user_id) { 'stevenzeiler' }
    let(:auth_provider) { 'twitter' }

    it 'should find gifts on twitter for a given user' do
      gift = create(:gift, { auth_provider: auth_provider, user_id: user_id })
      Gift.for_user(user_id, auth_provider).should == [gift]
    end

    it 'should not include gifts from other providers' do
      twitter_gift = create(:gift, { auth_provider: auth_provider, user_id: user_id })
      facebook_gift = create(:gift, { auth_provider: 'facebook', user_id: user_id })
      Gift.for_user(user_id, auth_provider).should == [twitter_gift]
    end
  end

  describe 'generating an invoice id' do
    it 'does not require an invoice id at first' do
      build(:gift, invoice_id: nil).should be_valid
    end

    it 'should generate an invoice id after saving' do
      gift = build(:gift)
      gift.invoice_id.should be_nil
      gift.save 
      gift.invoice_id.should_not be_nil
    end
  end

  describe 'funding a gift' do
    it 'should not be funded by default' do
      gift = build(:gift)
      gift.funded_at.should be_nil
    end
    
    it '#fund! should update the funded time' do
      gift = create(:gift)
      gift.fund! 
      gift.funded_at.should_not be_nil
    end

    it 'should return a list of funded gifts' do
      Gift.destroy_all
      Gift.funded.should be_empty 
      gift = create(:gift)
      Gift.funded.should be_empty 
      gift.fund!
      Gift.funded.should == [gift]
    end
  end

  describe 'claiming a gift' do
    let(:bitcoin_address) { 'me@stevenzeiler.com' }
    let!(:bitcoin_client) { 
      double('bitcoin_client') 
    }
  
    before do
      result = Struct.new(:success?)
      bitcoin_client.stub(:send_money).and_return(result.new(true))
    end

    it 'should not be claimed by default' do
      gift = build(:gift)
      gift.retrieved_at.should be_nil
    end

    it 'should not be able to be claimed if unfunded' do
      gift = create(:gift)
      expect(bitcoin_client).to_not receive(:send_money)
      gift.claim!(bitcoin_address, bitcoin_client)
    end

    it 'should be pay out bitcoins upon claiming gift' do
      gift = create(:gift)
      gift.fund!
      expect(bitcoin_client).to receive(:send_money).with(bitcoin_address, 0.01)
      gift.claim!(bitcoin_address, bitcoin_client)
    end

    it 'should set retrieved_at upon claiming' do
      gift = create(:gift)
      gift.fund!
      gift.retrieved_at.should be_nil
      expect(bitcoin_client).to receive(:send_money).with(bitcoin_address, 0.01)
      gift.claim!(bitcoin_address, bitcoin_client)
      gift.retrieved_at.should_not be_nil
    end

    it 'should set the recipient bitcoin address' do
      gift = create(:gift)
      gift.fund!
      gift.recipient_bitcoin_address.should be_nil
      expect(bitcoin_client).to receive(:send_money).with(bitcoin_address, 0.01)
      gift.claim!(bitcoin_address, bitcoin_client)
      gift.recipient_bitcoin_address.should == bitcoin_address
    end

    it '#unclaimed gifts should return a scope of gifts whose retrived_at is nil' do
      Gift.destroy_all
      gift = create(:gift)
      Gift.unclaimed.should == [gift]
      Gift.unclaimed.funded.should be_empty  

      gift.fund!
      Gift.unclaimed.should == [gift]
      gift.retrieved_at.should be_nil
      Gift.unclaimed.funded.should == [gift]

      gift.claim!(bitcoin_address, bitcoin_client)
      Gift.unclaimed.should be_empty 
      Gift.funded.should == [gift]
      gift.retrieved_at.should_not be_nil
    end
  end
end

