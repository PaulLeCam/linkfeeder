run = (mvc, exp) ->

  exp class Link extends mvc.Model

    idAttribute: "_id"
    urlRoot: "/links"

    parseTags: ->
      desc = @get "description"
      unless @has "tags"
        words = desc.split " "
        @set "tags", (w.substring(1, w.length) for w in words when w.charAt(0) is "#" and w.length > 1)

      tags = @get "tags"
      if tags.length
        desc = desc.replace "##{ tag }", "<a href='/#{ tag }'>##{ tag }</a>" for tag in tags
        @set "description", desc
      @


if typeof exports is "undefined" # Browser
  define ["ext/framework"], (framework) ->
    run framework.mvc, (c) -> c

else # Node
  {framework} = require "slob"
  run framework.mvc, (c) -> module.exports = c
