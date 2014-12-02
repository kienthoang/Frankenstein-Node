mongoose = require "mongoose"

EventSchema = new mongoose.Schema
  psql_id: String
  name: String
  time: Date
  actors: Array

Event = mongoose.model "Event", EventSchema
Event.createNewStage = (psql_id, name, callback) ->
  record = {psql_id, name}
  @create record, callback

module.exports = Event
