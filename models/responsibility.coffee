mongoose = require "mongoose"

ResponbilitySchema = new mongoose.Schema
  psql_id: String
  name: String

Responsibility = mongoose.model "Responsibility", ResponbilitySchema
Responsibility.createNewResponsibility = (psql_id, name, callback) ->
  record = {psql_id, name}
  @create record, callback

module.exports = Responsibility
