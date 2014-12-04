mongoose = require "mongoose"

# Create a user schema
ActorSchema = new mongoose.Schema
  psql_id: String
  name: String

# Return User model
Actor = mongoose.model "Actor", ActorSchema
Actor.createNewActor = (psql_id, name, callback) ->
  record = {psql_id, name}
  @create record, callback

Actor.findByPsqlId = (psql_id, callback) ->
  @findOne {psql_id}, callback

module.exports = Actor
