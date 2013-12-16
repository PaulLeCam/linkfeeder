run = (mvc, tmpl, exp) ->

  exp class LinkForm extends mvc.View

    template: tmpl

    render: ->
      @renderer @template()


if typeof exports is "undefined" # Browser
  define ["ext/framework", "templates/link-add"], (framework, tmpl) ->
    run framework.mvc, tmpl, (c) -> c

else # Node
  {framework} = require "slob"
  template = framework.template.compile require("fs").readFileSync("#{ __dirname }/../templates/Link-add.htm").toString()
  run framework.mvc, template, (c) -> module.exports = c
