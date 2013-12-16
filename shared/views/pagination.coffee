run = (framework, tmpl_list, tmpl_item, exp) ->

  framework.template.registerHelper "paginationItems", (pages = {}) ->
    items = []
    return "" if pages.last < 2

    items.push tmpl_item
      cls: if pages.current is 1 then "disabled" else ""
      url: if pages.current is 1 then "#" else "#{ pages.url }/#{ pages.current - 1 }"
      val: "&laquo;"

    for i in [1..pages.last] # Limit here eventually when there are too many pages
      items.push tmpl_item
        cls: if pages.current is i then "active" else ""
        url: "#{ pages.url }/#{ i }" # if pages.current is i then "#" else
        val: i

    items.push tmpl_item
      cls: if pages.current is pages.last then "disabled" else ""
      url: if pages.current is pages.last then "#" else "#{ pages.url }/#{ pages.current + 1 }"
      val: "&raquo;"

    if items.length > 1 then new framework.template.SafeString items.join ""
    else ""

  exp class Pagination extends framework.mvc.View

    template: tmpl_list

    initialize: (@options = {}) ->
      @options.size ?= 10
      @options.last = Math.floor @options.total / @options.size
      @options.last += 1 if @options.total % @options.size isnt 0

    render: ->
      @renderer @template @options


if typeof exports is "undefined" # Browser
  define ["ext/framework", "templates/pagination/list", "templates/pagination/item"], (framework, tmpl_list, tmpl_item) ->
    run framework, tmpl_list, tmpl_item, (c) -> c

else # Node
  {framework} = require "slob"
  tmpl_list = framework.template.compile require("fs").readFileSync("#{ __dirname }/../templates/pagination/list.htm").toString()
  tmpl_item = framework.template.compile require("fs").readFileSync("#{ __dirname }/../templates/pagination/item.htm").toString()
  run framework, tmpl_list, tmpl_item, (c) -> module.exports = c
