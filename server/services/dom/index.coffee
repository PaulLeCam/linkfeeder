debug = require("debug") "service:html"
getDom = require "./jsdom"
middlewares =
  meta: require "./meta"
  images: require "./images"

module.exports = (uri, extracts, cb) ->
  debug "extracting %s from %s", extracts.join(", "), uri
  getDom uri, (err, window) ->
    if err
      if err.code is "ENOTFOUND" then cb new Error "Not found"
      else cb err
    else
      res = {}
      res[func] = middlewares[func] window for func in extracts
      cb null, res
