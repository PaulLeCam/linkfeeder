module.exports = class BaseRouter

  constructor: (@app) ->
    @defineRoutes()

  defineRoutes: ->

  _handleError: (req, res, error) ->
    if req.is "json" then res.json error.code,
      status: "Error"
      error: error
    else res.render "error", {error}

  handleBadRequest: (req, res, error = {}) ->
    error.code ?= 400
    error.type ?= "Bad request"
    @_handleError req, res, error

  handleUnauthorized: (req, res, error = {}) ->
    error.code ?= 401
    error.type ?= "Unauthorized"
    @_handleError req, res, error

  handleForbidden: (req, res, error = {}) ->
    error.code ?= 403
    error.type ?= "Forbidden"
    @_handleError req, res, error

  handleNotFound: (req, res, error = {}) ->
    error.code ?= 404
    error.type ?= "Not found"
    @_handleError req, res, error

  handleServerError: (req, res, error = {}) ->
    error.code ?= 500
    error.type ?= "Server error"
    @_handleError req, res, error
