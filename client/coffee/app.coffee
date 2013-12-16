define [
  "sandbox/widget"
  "services/router"
  "./config"
], (sandbox, router) ->

  # Manage link creation from navbar

  $link_page = sandbox.dom.find "#link-page"
  $link_page_input = $link_page.find "input"
  $link_page_button = $link_page.find "button"

  submitForm = ->
    uri = $link_page_input.val()
    if uri? and uri.length
      sandbox.emit "navbar-form:disable"
      router.loadPage "links/create", uri
      router.navigate "links/new"
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
