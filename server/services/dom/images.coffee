module.exports = (window) ->
  $ = window.$
  res = []

  $("img").each (i, el) ->
    return unless el.width > 200 and el.height > 200
    $el = $ el
    res.push
      src: $el.attr "src"
      alt: $el.attr "alt"
      title: $el.attr "title"
      width: el.width
      height: el.height

  res
