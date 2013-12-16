_ = require "lodash"
debug = require("debug") "router:tags"
redis = require "../databases/redis"
Router = require "../components/routers/base"

class TagsRouter extends Router

  defineRoutes: ->
    @app.get "/:tag/:page?", => @read.apply @, arguments
    debug "ready"

  read: (req, res) ->
    page_size = 20
    page = req.params.page ? 1
    start = (page - 1) * page_size
    stop = page * page_size - 1
    tag = req.params.tag.toLowerCase()
    key = redis.prefix "tag:#{ tag }"
    redis.client.multi()
      .llen(key)
      .lrange(key, start, stop)
      .exec (err, data) =>
        if err then @handleServerError req, res, err
        else
          res_data =
            data: (JSON.parse p for p in data[1])
            tag: tag
            pages:
              url: "/#{ tag }"
              current: parseInt page, 10
              size: page_size
              total: data[0]
          if req.is "json" then res.json _.extend status: "OK", res_data
          else
            view = if req.xhr then "tag/_read" else "tag/read"
            res.render view, res_data

module.exports = (app) -> new TagsRouter app
