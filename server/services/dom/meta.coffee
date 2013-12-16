module.exports = (window) ->
  $ = window.$
  res =
    title: $("title").text()

  $("meta").each (i, el) ->
    $el = $ el
    if name = $el.attr "name"
      res[name] = $el.attr "content"

  res
