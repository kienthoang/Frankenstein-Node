mongoose = require "mongoose"

# Create a user schema
StageSchema = new mongoose.Schema
  psql_id: String
  name: String

# Return User model
Stage = mongoose.model "Stage", StageSchema
Stage.createNewStage = (psql_id, name, callback) ->
  record = {psql_id, name}
  @create record, callback

module.exports = Stage
