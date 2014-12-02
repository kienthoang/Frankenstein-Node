mongoose = require "mongoose"

CrewSchema = new mongoose.Schema
  psql_id: String
  name: String

Crew = mongoose.model "Crew", CrewSchema
Crew.createNewCrew = (psql_id, name, callback) ->
  record = {psql_id, name}
  @create record, callback

module.exports = Crew
