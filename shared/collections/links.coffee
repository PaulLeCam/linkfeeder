run = (mvc, Link, exp) ->

  exp class Links extends mvc.Collection

    model: Link
    url: "/links"


if typeof exports is "undefined" # Browser
  define ["ext/framework", "models/link"], (framework, Link) ->
    run framework.mvc, Link, (c) -> c

else # Node
  {framework} = require "slob"
  Link = require "../models/link"
  run framework.mvc, Link, (c) -> module.exports = c
