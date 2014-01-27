window.HomeView = Marionette.ItemView.extend
  template: '#homeView' 
  events:
    'click .sexyButton' : 'click'
  click: (e) ->
    e.preventDefault()
    url = $(e.target).attr('href')
    Backbone.history.navigate(url, trigger: true)
      
