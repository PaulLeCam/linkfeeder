debug = require("debug") "mongo"
mongoose = require "mongoose"

mongo_uri = process.env.MONGO_URI ? "mongodb://localhost:27017/linkfeeder"
db = mongoose.createConnection mongo_uri

db.on "error", debug
db.once "open", -> debug "connected to %s", mongo_uri

module.exports = {mongoose, db}
