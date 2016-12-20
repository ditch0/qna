window.App = {} unless window.App

App.utils =
  render: (template, data) ->
    JST["templates/#{template}"](data)

  extractFileNameFromUrl: (url) ->
    url = url.replace(/.*?([^\/]+)$/, '$1')
    decodeURIComponent(url)
