define [
  "sandbox/service"
], (sandbox) ->

  class Router extends sandbox.routing.Router

    pageRoutes:
      "":           "home"
      "links/new":  "links/create"
      "links/:id":  "links/read"
      ":tag":       "tags/read"
      ":tag/:page": "tags/read"

  new Router
