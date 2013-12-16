{db} = require "../databases/mongo"

module.exports =
  Link: db.model "Link", require "./schemas/link"
