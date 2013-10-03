function Invoice (recipient_twitter_username, bitcoin_amount) { 
  this.recipient_twitter_username = recipient_twitter_username;
  this.bitcoin_amount = bitcoin_amount;
};

Invoice.prototype.create = function () {
  var invoice = this;
  $.ajax({
    type: 'POST',
    url: '/api/gifts/twitter',
    data: {
      recipient_twitter_username: invoice.recipient_twitter_username,
      bitcoin_amount: invoice.bitcoin_amount
    },
    success: function(data) {
      invoice.display(data.invoiceUrl);
    },
    error: function(err){
      console.log(err);
    }
  })
};

Invoice.prototype.display = function (url) {
  if (window.plugins && window.plugins.childBrowser) {
    invoiceChildBrowser = window.plugins.childBrowser.showWebPage(url, {
      showLocationBar: true
    });

    invoiceChildBrowser.onLocationChange = function(loc) {
      if (loc.match(/^http:\/\/sendthembitcoins.com\/coinbase\/payments/)) {
        invoiceChildBrowser.close();
      } else {
        invoiceChildBrowser.close();
      }
    }

  } else {
    document.location.href = url;
  }
}