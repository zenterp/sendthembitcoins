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

console.log(App)

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var Invoice = (function(){
  function create(opts, fn) {
    var url = 'https://www.sendthembitcoins.com/api/ripple/bridge_invoices';
    $.ajax({
      url: url,
      dataType: 'json',
      type: 'post',
      data: opts,
      complete: fn
    });
  }
  return { create: create }
})();

RippleDeposit = Backbone.Marionette.ItemView.extend({
  template: '#rippleDeposit',
  events: {
    'submit form': 'submit'
  },
  submit: function(e) {
    $('#loading').show();
    e.preventDefault();
    var amount = $('#rippleBridgeForm input[name="amount"]').val();
    var address = $('#rippleBridgeForm input[name="ripple_address"]').val();
    Invoice.create({ ripple_address: address, amount: amount }, function(resp) {
      document.location.href = resp.responseJSON.invoice_url;
    })
  }
});

$(function(){

  var credentials;

  App.on('initialize:before', function(options){
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

  var NewEscrowView = Backbone.Marionette.ItemView.extend({
    template: '#newEscrowForm'
  });
  
  var RippleWithdraw = Backbone.Marionette.ItemView.extend({
    template: '#rippleWithdraw'
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
        },
        dataType: 'json'
      });
    },
    index: function() {
      App.main.show(new HomeView());
    },
    rippleDeposit: function() {
      App.main.show(new RippleDeposit());
    },
    rippleWithdraw: function() {
      App.main.show(new RippleWithdraw());
    }
  });

  router = new AppRouter;
  App.start();
});
