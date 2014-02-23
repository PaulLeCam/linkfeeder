define [
  "sandbox/service"
], (sandbox) ->

  class Router extends sandbox.routing.Router

    pageRoutes:
      "":           "home"
      ":tag":       "tags/read"
      ":tag/:page": "tags/read"
      "links/:id":  "links/read"
      "links/new":  "links/create"

  new Router
