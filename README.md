--------- HTTP JSON REST API--------- 

POST /api/apivoices

  Required Params:

    recipient_twitter_username : String
    bitcoin_amount             : Float

Redirects to coinbase invoice payment page

The clients will need to be able to see a list
of the signed-in user's available gifts for claiming.

GET /api/user/gifts

  Session Required

  Returns an array of gifts available to be claimed.

    gift_amount: Float,
    claim_url: URL

POST /api/user/gifts/:id

  Required Params:

    receipt_bitcoin_address: BitcoinAddress