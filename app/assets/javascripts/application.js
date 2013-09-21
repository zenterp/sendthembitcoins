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
  window.gifts = gifts;

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
      'twitter/gifts/new' : 'newGift',
      'gifts/claimable' : 'gifts',
      'user/coinbase' : 'coinbase',
      'addresses/receive' : 'configReceiveAddress'
    },

    index: function() {
      this.hideAll();
      $('#homePage').show();
      $('#twitterGifts').show();
      $('#sendViaTwitter').show();
    },
    newGift: function() {
      $('#homePage, #twitterGifts').hide();
      $('#newInvoice, #newInvoice .sexyButton').show();
    },
    gifts: function () {
      this.hideAll();
      gifts.fetch({
        success: function (data) {
          console.log('gifts', data);
          /*$("#claimableGifts ul").html('');
          var $listItems = $('<ul/>');
          for (i=0;i<gifts.models.length;i++) {
            var gift = gifts.models[i];
            li = giftListItemTemplate(gift.attributes);
            $listItems.append(li);
          }*/
          $('#claimableGifts').show();
          $('#configureReceiveAddresses').show();
          //$("#claimableGifts ul").append($listItems.html());
        }
      })
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
    configReceiveAddress: function () {
      this.hideAll();
      $('#configReceiveAddresses').show();
      $('#configReceiveAddresses .sexyButton').show();
    },
    hideAll: function () {
      $('.page-content div').hide();
      $('form').hide();
      $('.sexyButton').hide();
    }
  });

  window.app = new AppRouter;


  $('#newInvoice').on('submit', function(e) {
    e.preventDefault();
    var recipient_twitter_username = $('input[name="recipient_twitter_username"]').val();
    var bitcoin_amount = $('input[name="bitcoin_amount"]').val();
    var invoice = new Invoice(recipient_twitter_username, bitcoin_amount);
    invoice.create();
  });

  $('#configReceiveAddresses').on('submit', function(e) {
    e.preventDefault();
    console.log('config address "claim!" form submitted.');
  })

  $('.sexyButton, .page-header a').on('click', function (e) {
    //e.preventDefault();

    var href = $(this).attr('href');
    if ($(this).attr('id') == 'connectCoinbase') {
      document.location.href = '/auth/coinbase';
    }

    if (href) {
      app.navigate($(this).attr('href'), {trigger: true});
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


  Backbone.history.start({
    pushState: true,
    silent: false
  });

});