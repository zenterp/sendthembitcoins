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
//= require backbone.marionette.min
//= require_tree ./models
//= require_tree ./collections
//= require_tree .
//= require_self  

console.log('HomeView', HomeView);

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

$(function(){

  var App = new Backbone.Marionette.Application()
    , credentials;

  window.App = App;
  App.on('initialize:before', function(options){
    console.log('check if there is some user');
    console.log(window.auth);
    credentials = new Backbone.Model(window.auth);
  });

  App.on('initialize:after', function(options){
    Backbone.history.start({
      pushState: true,
      silent: false
    });
  });

  App.addRegions({
    header: '.page-header',
    main: '.page-content'  
  });

  
  window.NewEscrowView = Backbone.Marionette.ItemView.extend({
    template: '#newEscrowForm'
  });
  
  window.RippleBridgeForm = Backbone.Marionette.ItemView.extend({
    template: '#rippleBridgeForm'
  });

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

  var AppRouter = Backbone.Router.extend({
    routes: {
      '' : 'index',
      'ripple/deposit': 'rippleDeposit',
      'ripple/withdraw': 'rippleWithdraw',
      'escrows':'escrows',
      'escrows/new': 'newEscrow'
    },
    newEscrow: function(){
      App.main.show(new NewEscrowView()); 
    },
    escrows: function() {
      $.ajax({
        url: '/api/escrows',
        data: { auth_provider: auth.provider, auth_uid: auth.uid },
        success: function(escrows){
          console.log('got the escrows');
          console.log(escrows);
        },
        dataType: 'json'
      });
      console.log('window.auth', window.auth);
    },
    index: function() {
      App.main.show(new HomeView());
    },
    rippleDeposit: function() {
      App.main.show(new RippleBridgeForm());
    },
    rippleWithdraw: function() {
      App.main.show(new RippleBridgeForm());
    }
  });


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

  router = new AppRouter;
  App.start();

});
