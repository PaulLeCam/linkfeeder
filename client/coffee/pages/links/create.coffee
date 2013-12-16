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
      sandbox.widgets.initialize "link-add",
        el: "#link-add"
        uri: @target

      sandbox.on "link:create", (model) ->
        sandbox.widgets.remove "#link-add"
        new LinkView(
          el: "#content"
          model: model
        ).render()
        router.setPage "links/read", model.url()
        sandbox.emit "navbar-form:enable"

    start: (previous, @target) ->
      sandbox.emit "navbar-form:disable"
      if previous then @load().done => @ready()
      else @ready()

    stop: ->
      sandbox.widgets.remove "#link-add"
