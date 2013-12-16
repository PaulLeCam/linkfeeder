debug = require("debug") "server"
express = require "express"
app = express()
env = app.settings.env

app.engine "jade", require("jade").__express

app.configure ->
  @set "views", "#{ __dirname }/views"
  @set "view engine", "jade"

  @use express.logger "dev"
  @use express.compress()
  # Statics
  @use express.favicon()
  if env is "production"
    @use express.static "#{ __dirname }/../client/www"
  else
    @use express.static "#{ __dirname }/../client/build"
    @use "/js/bower_components/", express.static "#{ __dirname }/../client/bower_components"
  # Data
  @use express.bodyParser()
  # Locals
  @use require("slob").middleware "#{ __dirname }/../shared"
  # Error handling
  @use express.errorHandler()

require("./routes/links") app
require("./routes/default") app
require("./routes/tags") app

port = process.env.PORT ? 3000
app.listen port
debug "listening on port #{ port }"
