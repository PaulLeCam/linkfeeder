run = (mvc, Link, tmpl, exp) ->

  exp class Link extends mvc.View

    Model: Link
    template: tmpl
    urlRoot: "/links"

    initialize: ->
      @model.parseTags()

    render: ->
      @renderer @template @model.toJSON()


if typeof exports is "undefined" # Browser
  define ["ext/framework", "models/link", "templates/link"], (framework, Link, tmpl) ->
    run framework.mvc, Link, tmpl, (c) -> c

else # Node
  {framework} = require "slob"
  Link = require "../models/link"
  template = framework.template.compile require("fs").readFileSync("#{ __dirname }/../templates/link.htm").toString()
  run framework.mvc, Link, template, (c) -> module.exports = c
