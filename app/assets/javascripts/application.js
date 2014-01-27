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

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var Invoice = (function(){
  function create(opts, fn) {
    $.ajax({
      url: '/api/ripple/bridge_invoices',
      dataType: 'json',
      type: 'post',
      data: opts,
      complete: function(resp) {
        fn(resp.responseJSON);
      }
    });
  }
  return { create: create }
})();

RippleDepositView = Backbone.Marionette.ItemView.extend({
  template: '#rippleDeposit',
  events: {
    'submit form': 'submit'
  },
  submit: function(e) {
    $('#loading').show();
    e.preventDefault();
    var formData = $('form').serializeObject();
    Invoice.create(formData, function(invoice) {
      document.location.href = invoice.invoice_url;
    })
  }
});

var RowView = Backbone.Marionette.ItemView.extend({
  tagName: "tr",
  template: "#row-template",
  events: {
    'click a': 'accept'
  },
  accept: function() {
    $('#loading').show();
    var escrows = this.model.collection;
    var opts = new Object(auth);
    opts.bitcoin_address = $('input').val();
    this.model.accept(opts, function(response){
      escrows.fetch({ data: {
        auth_provider: auth.provider,
        auth_uid: auth.uid
      },
      success: function(){
        $('#loading').hide();
      }});
    });
  }
});

var NoItemsView = Marionette.ItemView.extend({
  template: '#noEscrowsTemplate'
});

var EscrowsTableView = Backbone.Marionette.CompositeView.extend({
  itemView: RowView,
  itemViewContainer: "tbody",
  template: "#table-template",
  emptyView: NoItemsView
});

var Credentials = Backbone.Model.extend({
  defaults: {
    'auth_provider': ''
  } 
})

$(function(){

  var credentials;

  App = new Backbone.Marionette.Application;

  App.on('initialize:before', function(options){
    // the `auth` object is passed in to a preceeding <script> using ERB
    credentials = new Credentials(auth);
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

  var Escrow = Backbone.Model.extend({ 
    accept: function(opts, fn) {
      var url = '/api/escrows/'+this.get('id')+'/accept';
      $.ajax({
        type: 'post',
        dataType: 'json',
        url: url,
        data: opts,
        success: fn
      }); 
    }
  });

  var Escrows = Backbone.Collection.extend({
    model: Escrow,
    url: '/api/escrows'
  });

  var escrows = new Escrows();

  var NewEscrowView = Backbone.Marionette.ItemView.extend({
    template: '#newEscrowForm',
    events: {
      'submit form': 'submit'
    },
    submit: function(event) {
      event.preventDefault();
      var formData = $(event.target).serializeObject();
      $('#loading').show();
      escrows.create(formData, { 
        success: function(escrow){
          document.location.href = escrow.get('invoice_url');
        }
      });
    }
  });
  
  var RippleWithdrawView = Backbone.Marionette.ItemView.extend({
    template: '#rippleWithdraw'
  });

  var HeaderView = Backbone.Marionette.ItemView.extend({
    template: '#headerTemplate',
    events: {
      'click a': 'home'
    },
    home: function(event){
      event.preventDefault();
      Backbone.history.navigate('/', { trigger: true });
    }
  })

  App.header.show(new HeaderView);

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
      escrows.fetch({ data: {
        auth_provider: auth.provider,
        auth_uid: auth.uid
      }});
      App.main.show(new EscrowsTableView({
        collection: escrows,
        model: credentials
      }));
    },
    index: function() {
      App.main.show(new HomeView);
    },
    rippleDeposit: function() {
      App.main.show(new RippleDepositView);
    },
    rippleWithdraw: function() {
      App.main.show(new RippleWithdrawView);
    }
  });

  router = new AppRouter;
  App.start();
});
