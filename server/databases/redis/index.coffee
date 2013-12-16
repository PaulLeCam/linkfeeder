debug = require("debug") "redis"
redis = require "redis"

port = process.env.REDIS_PORT ? 6379
host = process.env.REDIS_HOST ? "localhost"
pass = process.env.REDIS_PASS ? null

client = redis.createClient port, host
client.auth pass if pass?

client.once "ready", -> debug "connected to #{ host }:#{ port }"
client.on "error", debug

prefix = (key) -> "linkfeeder:#{ key }"

module.exports = {prefix, client}
