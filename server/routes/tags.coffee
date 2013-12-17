_ = require "lodash"
async = require "async"
debug = require("debug") "router:tags"
redis = require "../databases/redis"
Router = require "../components/routers/base"
{Link} = require "../models"

class TagsRouter extends Router

  pageSize: 20

  defineRoutes: ->
    @app.get "/:tag/:page?", => @read.apply @, arguments
    debug "ready"

  read: (req, res) ->
    tag = req.params.tag.toLowerCase()
    if tag.indexOf("+") isnt -1 then @_readMulti req, res, tag
    else @_readOne req, res, tag

  _readOne: (req, res, tag) ->
    page = req.params.page ? 1
    start = (page - 1) * @pageSize
    stop = page * @pageSize - 1
    key = redis.prefix "tag:#{ tag }:recent"
    redis.client.multi()
      .llen(key)
      .lrange(key, start, stop)
      .zrevrange(redis.prefix("tag:#{ tag }:related"), 0, 9, "withscores")
      .exec (err, data) =>
        if err then @handleServerError req, res, err
        else
          if data[2].length
            related = {}
            related[t] = parseInt data[2][i+1], 10 for t, i in data[2] by 2
          else related = null
          res_data =
            data: (JSON.parse p for p in data[1])
            multi: no
            tag: tag
            related: related
            pages:
              url: "/#{ tag }"
              current: parseInt page, 10
              size: @pageSize
              total: data[0]
          if req.is "json" then res.json _.extend status: "OK", res_data
          else
            view = if req.xhr then "tag/_read" else "tag/read"
            res.render view, res_data

  _readMulti: (req, res, tag) ->
    tags = tag.split "+"
    tasks = [["sinter", (redis.prefix "tag:#{ t }:links" for t in tags)]]
    total_key = redis.prefix "tags:total"
    tags.forEach (t) ->
      tasks.push ["zscore", total_key, t]
    redis.client.multi(tasks).exec (err, data) =>
      if err then @handleServerError req, res, err
      else
        tag_index = {}
        tag_index[ t ] = i+1 for t, i in tags
        sorted_tags = _.sortBy tags, (t, i) ->
          if data[ i+1 ] then -parseInt data[ i+1 ], 10
          else 1
        related = {}
        related[ t ] = data[ tag_index[ t ] ] for t in sorted_tags
        res_data =
          data: []
          multi: yes
          tag: tag
          related: related
          pages:
            url: "/#{ tag }"
            current: 1
            size: @pageSize
            total: 1
        if data[0].length
          Link.find {_id: {$in: data[0]}}, (err, docs) =>
            if err then @handleServerError req, res, err
            else
              res_data.data = docs
              if req.is "json" then res.json _.extend status: "OK", res_data
              else
                view = if req.xhr then "tag/_read" else "tag/read"
                res.render view, res_data
        else
          if req.is "json" then res.json _.extend status: "OK", res_data
          else
            view = if req.xhr then "tag/_read" else "tag/read"
            res.render view, res_data

module.exports = (app) -> new TagsRouter app
