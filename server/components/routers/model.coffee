debug = require("debug") "router:model"
BaseRouter = require "./base"

module.exports = class ModelRouter extends BaseRouter

  constructor: (app, @Model) ->
    @modelName ?= @Model.modelName.toLowerCase()
    @routePrefix ?= "/#{ @modelName }s"
    @debug = require("debug") "router:#{ @modelName }"
    super app

  #
  # Routing
  #

  defineRoutes: ->
    # Create
    @app.post @routePrefix,
      => @checkPermissions("create").apply @, arguments
      => @checkInputData.apply @, arguments
      => @create.apply @, arguments
    @app.get "#{ @routePrefix }/new",
      => @checkPermissions("createForm").apply @, arguments
      => @createForm.apply @, arguments
    # List/find
    @app.get @routePrefix,
      => @checkPermissions("list").apply @, arguments
      => @list.apply @, arguments
    # Read
    @app.get "#{ @routePrefix }/:id",
      => @findRead.apply @, arguments
      => @checkPermissions("read").apply @, arguments
      => @read.apply @, arguments
    # Update
    @app.put "#{ @routePrefix }/:id",
      => @findById.apply @, arguments
      => @checkPermissions("update").apply @, arguments
      => @checkInputData.apply @, arguments
      => @update.apply @, arguments
    @app.get "#{ @routePrefix }/:id/edit",
      => @findById.apply @, arguments
      => @checkPermissions("updateForm").apply @, arguments
      => @updateForm.apply @, arguments
    # Delete
    @app.delete "#{ @routePrefix }/:id",
      => @findById.apply @, arguments
      => @checkPermissions("delete").apply @, arguments
      => @delete.apply @, arguments
    @debug "ready"

  #
  # Security middlewares
  #

  permissions:
    create: -> yes
    createForm: -> yes
    list: -> yes
    read: -> yes
    update: -> no
    updateForm: -> yes
    delete: -> yes

  checkPermissions: (action) ->
    testFunc = @permissions[action]

    unless testFunc?
      debug "Missing permissions for action %s", action
      testFunc = -> no # Forbid everything

    (req, res, next) =>
      if testFunc req then next()
      else @handleForbidden req, res

  checkInputData: (req, res, next) -> next()

  #
  # Utility middlewares
  #

  populate: []

  _doPopulate: (find) ->
    for p in @populate
      if Array.isArray p then find.populate.apply find, p
      else find.populate p

  findRead: (req, res, next) ->
    find = @Model.findById req.params.id
    @_doPopulate find
    find.exec (err, doc) =>
      if err
        if err.message is "Invalid ObjectId" then @handleNotFound req, res, err
        else @handleServerError req, res, err
      else unless doc? then @handleNotFound req, res
      else
        req.model = doc
        next()

  findBySlug: (req, res, next) ->
    find = @Model.findOne slug: req.params.slug
    @_doPopulate find
    find.exec (err, doc) =>
      if err
        if err.message is "Invalid ObjectId" then @handleNotFound req, res, err
        else @handleServerError req, res, err
      else unless doc? then @handleNotFound req, res
      else
        req.model = doc
        next()

  findById: (req, res, next) ->
    @Model.findById req.params.id, (err, doc) =>
      if err
        if err.message is "Invalid ObjectId" then @handleNotFound req, res, err
        else @handleServerError req, res, err
      else unless doc? then @handleNotFound req, res
      else
        req.model = doc
        next()

  #
  # Other utilities
  #

  _resErr: (req, res, err) ->
    if err.code is 11000
      key = err.err?.match(/\$(.*)_[0-9]+/i)?[1]
      if key then return @handleBadRequest req, res,
        type: "Duplicate key"
        key: key
    @handleServerError req, res, err

  _resDoc: (req, res, doc) ->
    if req.is "json" then res.json
      status: "OK"
      data: doc
    else res.redirect "#{ @modelName }s/#{ doc._id }"

  #
  # Actions
  #

  create: (req, res) ->
    new @Model(req.body).save (err, doc) =>
      if err then @_resErr req, res, err
      else @_resDoc req, res, doc

  createForm: (req, res) ->
    if req.is "json" then @handleBadRequest req, res
    else res.render "#{ @modelName }/create"

  list: (req, res) ->
    @Model.find req.query, (err, docs) =>
      if err then @handleServerError req, res, err
      else unless docs? then @handleNotFound req, res
      else if req.is "json" then res.json
        status: "OK"
        data: docs
      else res.render "#{ @modelName }/list",
        data: docs

  read: (req, res) ->
    if req.is "json" then res.json
      status: "OK"
      data: req.model
    else res.render "#{ @modelName }/read",
      data: req.model

  update: (req, res) ->
    req.model[k] = v for k, v of req.body
    req.model.save (err, doc) =>
      if err then @handleServerError req, res, err
      else @_resDoc req, res, doc

  updateForm: (req, res) ->
    if req.is "json" then @handleBadRequest req, res
    else res.render "#{ @modelName }/update",
      data: req.model

  delete: (req, res) ->
    req.model.remove (err) =>
      if err then @handleServerError req, res, err
      else if req.is "json" then res.json status: "OK"
      else res.redirect "#{ @modelName }/list"
