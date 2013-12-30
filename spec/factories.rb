FactoryGirl.define do
  factory :gift do
    bitcoin_amount 0.01
    user_id 1
    auth_provider 'facebook'  
  end
end
