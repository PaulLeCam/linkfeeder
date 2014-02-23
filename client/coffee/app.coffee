define [
  "sandbox/widget"
  "services/router"
  "views/link"
  "./config"
], (sandbox, router, LinkView) ->

  # Manage link creation from navbar

  $link_page = sandbox.dom.find "#link-page"
  $link_page_input = $link_page.find "input"
  $link_page_button = $link_page.find "button"

  sandbox.widgets.initialize "link-add-modal",
    el: ".link-add-modal"

  submitForm = ->
    sandbox.widgets.start "link-add-modal",
      el: ".link-add-modal"
      uri: $link_page_input.val()
      sandbox.emit "navbar-form:disable"
    no

  sandbox.on "navbar-form:disable", ->
    $link_page.off "submit", submitForm
    $link_page_input.val ""
    $link_page_input.prop "disabled", yes
    $link_page_button.prop "disabled", yes

  sandbox.on "navbar-form:enable", ->
    $link_page.on "submit", submitForm
    $link_page_input.prop "disabled", no
    $link_page_button.prop "disabled", no

  sandbox.on "link:created", (model) ->
    sandbox.widgets.stop "link-add-modal", "*"
    new LinkView(
      el: "#content"
      model: model
    ).render()
    router.setPage "links/read", model.url()

  router.on "route", (page) ->
    sandbox.emit "navbar-form:enable" unless page is "links/create"

  # Hijack local links to trigger router

  domain = window.location.origin
  sandbox.dom.find(document).on "click", "a[href^='/']", (e) ->
    route = e.currentTarget.href.replace "#{ domain }/", ""
    router.navigate route, trigger: yes
    no

  # Setup

  sandbox.dom.ready ->
    sandbox.routing.start
      pushState: on
