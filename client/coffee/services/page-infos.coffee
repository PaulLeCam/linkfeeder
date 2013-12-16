define [
  "sandbox/service"
], (sandbox) ->

  (uri) ->
    sandbox.http.post "/default/infos", {uri}
