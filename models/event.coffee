mongoose = require "mongoose"

EventSchema = new mongoose.Schema
  psql_id: String
  name: String
  description: String
  time: Date
  actors: Array
  duration: Number
  stage_psql_id: String

Event = mongoose.model "Event", EventSchema
module.exports = Event
