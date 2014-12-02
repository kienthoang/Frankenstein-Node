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
Event.findByPsqlId = (psql_id, callback) ->
  @find {psql_id}, callback

module.exports = Event
