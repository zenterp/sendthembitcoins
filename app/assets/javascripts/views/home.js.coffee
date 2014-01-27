window.HomeView = Marionette.ItemView.extend
  template: '#homeView' 
  events:
    'click .sexyButton' : 'click'
  click: (e) ->
    e.preventDefault()
    url = $(e.target).attr('href')
    if url.match(/^\/auth/)
      $('#loading').show()
      document.location.href = url
    else
      Backbone.history.navigate(url, trigger: true)
      
