debug = require("debug") "router:default"
redis = require "../databases/redis"
Router = require "../components/routers/base"
dom = require "../services/dom"

class DefaultRouter extends Router

  defineRoutes: ->
    @app.get "/", => @home.apply @, arguments
    @app.post "/default/infos", => @infos.apply @, arguments
    debug "ready"

  home: (req, res) ->
    page_size = 30
    page = req.query.page ? 1
    start = (page - 1) * page_size
    stop = page * page_size - 1
    links_key = redis.prefix "links:recent"
    tags_key = redis.prefix "tags:total"
    redis.client.multi()
      .llen(links_key)
      .lrange(links_key, start, stop)
      .zrevrange(tags_key, 0, 9, "withscores")
      .exec (err, data) =>
        if err then @handleServerError req, res, err
        else
          links = (JSON.parse p for p in data[1])
          if data[2].length
            tags = {}
            tags[t] = parseInt data[2][i+1], 10 for t, i in data[2] by 2
          else tags = null
          if req.is "json" then res.json
            status: "OK"
            links:
              total: data[0]
              data: links
            tags: tags
          else
            view = if req.xhr then "default/_home" else "default/home"
            res.render view,
              links:
                total: data[0]
                data: links
              tags: tags

  infos: (req, res) ->
    dom req.body.uri, ["meta", "images"], (err, data) =>
      if err then @handleNotFound req, res
      else res.json data

module.exports = (app) -> new DefaultRouter app
