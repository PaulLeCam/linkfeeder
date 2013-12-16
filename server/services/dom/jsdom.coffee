jsdom = require "jsdom"
jquery = require("fs").readFileSync("client/bower_components/jquery/jquery.min.js").toString()

module.exports = (uri, cb) ->
  jsdom.env
    url: uri
    src: [jquery]
    done: cb
