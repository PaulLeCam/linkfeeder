redis = require "../databases/redis"
Router = require "../components/routers/model"
{Link} = require "../models"

class LinksRouter extends Router

  createForm: (req, res) ->
    if req.xhr then res.render "#{ @modelName }/_create"
    else super req, res

  create: (req, res) ->
    data = req.body
    if data.description?.length
      words = data.description.split " "
      data.tags = (w.substring(1, w.length) for w in words when w.charAt(0) is "#")
    new @Model(req.body).save (err, doc) =>
      if err then @_resErr req, res, err
      else if data.tags?
        redis_doc = JSON.stringify doc
        recent_key = redis.prefix "links:recent"
        tasks = [
          ["lpush", recent_key, redis_doc]
          ["ltrim", recent_key, 0, 99]
        ]
        data.tags.forEach (t) ->
          t = t.toLowerCase()
          tag_key = redis.prefix "tag:#{ t }"
          tasks.push ["lpush", tag_key, redis_doc]
          tasks.push ["ltrim", tag_key, 0, 99]
          tasks.push ["zincrby", redis.prefix("tags:total"), 1, t]
        redis.client.multi(tasks).exec (err) =>
          if err then @_resErr req, res, err
          else @_resDoc req, res, doc
      else @_resDoc req, res, doc

  read: (req, res) ->
    if req.xhr then res.render "#{ @modelName }/_read",
      data: req.model
    else super req, res

module.exports = (app) -> new LinksRouter app, Link
