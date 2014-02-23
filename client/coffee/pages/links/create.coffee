define [
  "sandbox/widget"
  "services/router"
  "components/page"
  "views/link"
], (sandbox, router, Page, LinkView) ->

  class CreateLinkPage extends Page

    el: "#content"
    url: "/links/new"

    ready: ->
      sandbox.emit "navbar-form:disable"
      sandbox.widgets.start "link-add",
        el: ".link-add"
        target: @target

    start: (previous, @target) ->
      if previous then @load().done => @ready()
      else @ready()

    stop: ->
      sandbox.widgets.remove ".link-add"
