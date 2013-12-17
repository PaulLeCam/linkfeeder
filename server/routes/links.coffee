_ = require "lodash"
_.str = require "underscore.string"
redis = require "../databases/redis"
Router = require "../components/routers/model"
{Link} = require "../models"

class LinksRouter extends Router

  createForm: (req, res) ->
    if req.xhr then res.render "#{ @modelName }/_create"
    else super req, res

  _createTag: (t) ->
    t = t.substring 1, t.length # Remove sharp
    t = _.str.slugify t # Normalize
    t = t.substr 0, t.length-1 while t[ t.length-1 ] is "-" # Remove special characters
    t

  create: (req, res) ->
    data = req.body
    if data.description?.length
      words = data.description.split " "
      data.tags = (@_createTag w for w in words when w.charAt(0) is "#" and w.length > 1)
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
          tasks.push ["zincrby", redis.prefix("tags:total"), 1, t] # Increment tag count
          tasks.push ["sadd", redis.prefix("tag:#{ t }:links"), doc._id] # Add link to tag's set
          recent_key = redis.prefix "tag:#{ t }:recent"
          tasks.push ["lpush", recent_key, redis_doc] # Add Link to list cache for tag
          tasks.push ["ltrim", recent_key, 0, 99] # Limit list to 100 elements
          related_key = redis.prefix "tag:#{ t }:related"
          tasks.push ["zincrby", related_key, 1, r]  for r in data.tags when r isnt t # Add related tag to set
        redis.client.multi(tasks).exec (err) =>
          if err then @_resErr req, res, err
          else @_resDoc req, res, doc
      else @_resDoc req, res, doc

  read: (req, res) ->
    if req.xhr then res.render "#{ @modelName }/_read",
      data: req.model
    else super req, res

module.exports = (app) -> new LinksRouter app, Link
