// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require underscore-min
//= require backbone-min
//= require_tree .
//= require_self  

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

$(function(){

  var Growl = (function() {
    function show() {
    }

    function setText() {
    }

    function Hide() {
    }

    return {
      show: show,
      setText: setText,
      hide: hide
    }
  })

  var Gift = Backbone.Model.extend({
    claim: function(bitcoin_address, callback) {
      id = this.get('id');
      $.ajax({
        type: "POST",
        beforeSend: function(xhr) {
          var token = $('meta[name="csrf-token"]').attr('content');
          xhr.setRequestHeader('X-CSRF-Token', token);
        },
        url: '/api/user/gifts/'+id+'/claim',
        data: {
          receive_address: bitcoin_address
        },
        success: function(data) {
          callback(data);
        }
      });
    }
  });

  var Gifts = Backbone.Collection.extend({
    model: Gift
  });

  var gifts = new Gifts();
  gifts.url = '/api/user/gifts/claimable';

  var User = Backbone.Model.extend({
    url: function () {
      return '/api/user'
    }
  });

  currentUser = new User();
  currentUser.fetch();

  var giftListItemTemplate = _.template($("#giftListItem").html());
  var coinbaseAccountTemplate = _.template($("#coinbaseAccount").html());

  var AppRouter = Backbone.Router.extend({
    routes: {
      '' : 'index',
      'twitter/gifts/new' : 'newTwitterGift',
      'twitter/gifts/new' : 'newGithubGift',
      'gifts/claimable' : 'gifts',
      'user/coinbase' : 'coinbase',
      'addresses/receive' : 'configReceiveAddress',
      'networks/select': 'chooseNetworkToAuth',
      'ripple-bridge': 'rippleBridges',
      'ripple-bridge/withdraw': 'withdrawFromRipple',
      'escrows':''
    },
    escrows: function() {
      this.hideAll();
      alert(window.auth);
      console.log('window.auth', window.auth);
    },
    index: function() {
      this.hideAll();
      $('#homePage, #homePage div').show();
      
      $('#sendViaButtons, #sendViaButtons .sendViaButton').show();
    },
    newTwitterGift: function() {
      $('#homePage, #twitterGifts').hide();
      $('#newInvoice, #newInvoice .sexyButton').show();
    },
    newGithubGift: function() {
      $('#homePage, #twitterGifts').hide();
      $('#newInvoice, #newInvoice .sexyButton').show();
    },
    chooseNetworkToAuth: function() {
      $('#homePage, #twitterGifts').hide();
      $('#loginToClaim div, #loginToClaim').show();
    },
    rippleBridges: function() {
      this.hideAll()
      $('#rippleBridgeForm').show()
      $('#rippleNext').show()
    },
    gifts: function () {
      this.hideAll();
      $('#loading').show();
      $.getJSON('/api/user/gifts/claimable', function(data) {
        var gifts = data.gifts.claimable;
        $('#loading').hide();
        $('#claimableGifts').show();
        $('#configReceiveAddresses').show();
        $('#manualAddress').show();
        $('#configReceiveAddresses .sexyButton').show();
        $("#claimableGifts ul").html(gifts.count+' gifts totaling '+gifts.total+' bitcoins');
      });
    },
    coinbase: function () {
      $("#connectCoinbase").hide();
      currentUser.fetch({
        success: function () {
          var html = coinbaseAccountTemplate(currentUser.attributes);
          console.log(html);
          $('#coinbase').append(html);
          $('#coinbase').show();
        }
      });
    },
    withdrawFromRipple: function() {
      this.hideAll();
      $('#withdrawFromRipple').show()
      $('#withdrawFromRipple input[type="submit"]').show()
    },
    configReceiveAddress: function () {
      this.hideAll();
      $('#configReceiveAddresses').show();
      $('#manualAddress').show();
      $('#configReceiveAddresses .sexyButton').show();
    },
    hideAll: function () {
      $('.page-content div').hide();
      $('#bridgeRippleAddress').hide();
      $('form').hide();
      $('.sexyButton').hide();
    }
  });

  window.app = new AppRouter;


  $('#newInvoice').on('submit', function(e) {
    $('#loading').show();
    e.preventDefault();
    var recipient_twitter_username = $('input[name="recipient_twitter_username"]').val();
    var bitcoin_amount = $('input[name="bitcoin_amount"]').val();
    var invoice = new Invoice(recipient_twitter_username, bitcoin_amount);
    invoice.create();
  });

  $('#configReceiveAddresses').on('submit', function(e) {
    e.preventDefault();
    $('#loading').show();
    console.log('config address "claim!" form submitted.');
  })

  $('.sexyButton, .page-header a').on('click', function (e) {
    //e.preventDefault();

    var href = $(this).attr('href');
    if ($(this).attr('id') == 'connectCoinbase') {
      $('#loading').show();
      document.location.href = '/auth/coinbase';
    }

    if (href) {
      if (href.match(/^\/auth\//)) {
        $('#loading').show();
        document.location.href = href;
      } else {
        app.navigate(href, {trigger: true});
      }
    }
  });

  if (window.plugins && window.plugins.childBrowser) {
    $('#twitterGifts').on('click', function(e) {
      e.preventDefault();
      window.plugins.childBrowser.showWebPage('/auth/twitter', {
        showLocationBar: true
      });
    })
  } else {
    $('#twitterGifts').on('click', function(e) {
      $('#loading').show();
      console.log('clicked');
      e.preventDefault();
      document.location.href = '/auth/twitter';
    })
  }


  window.setCoinbaseAddress = function (callback) {
    $.ajax({
      type: "POST",
      beforeSend: function(xhr) {
        var token = $('meta[name="csrf-token"]').attr('content');
        xhr.setRequestHeader('X-CSRF-Token', token);
      },
      url: '/api/addresses/coinbase',
      success: function(data) {
        callback(data);
      }
    });
  }

  $('#withdrawFromRipple').on('submit', function(e) {
    e.preventDefault();
    $('#loading').show();
    var bitcoinAddress = $('#destinationBitcoinAddress').val();
    $.getJSON('/api/ripple/bridges/ripple-to-bitcoin/'+bitcoinAddress, function(resp){
      var tag = resp.rippleAddress.split('?dt=')[1];
      $('#bridgeRippleAddress').text('Send bitcoin IOUs to '+resp.rippleAddress+' with destinationTag '+tag);
      $('#bridgeRippleAddress').show();
      $('#loading').hide()
    })
  })

  $('#rippleBridgeForm').on('submit',function(e) {
    e.preventDefault()
    var ripple_address = $("#rippleBridgeForm input[name='ripple_address']").val()
    var amount = $("#rippleBridgeForm input[name='amount']").val()
    $('#loading').show()
    $.ajax({
      url: 'https://www.sendthembitcoins.com/api/ripple/bridge_invoices',
      data: { ripple_address: ripple_address , amount: amount},
      dataType: 'json',
      type: 'POST',
      success: function(data){
        document.location.href = data.invoice_url
      }
    })
  })

  Backbone.history.start({
    pushState: true,
    silent: false
  });

});
