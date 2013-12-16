{mongoose} = require "../../databases/mongo"

schema = new mongoose.Schema
  uri:
    type: String
    required: yes
  count:
    type: Number
    default: 0
  title: String
  description: String
  tags: [String]

module.exports = schema
