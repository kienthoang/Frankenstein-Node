mongoose = require "mongoose"

RoleSchema = new mongoose.Schema
  psql_id: String
  name: String

Role = mongoose.model "Role", RoleSchema
Role.createNewRole = (psql_id, name, callback) ->
  record = {psql_id, name}
  @create record, callback

Role.findByPsqlId = (psql_id, callback) ->
  @findOne {psql_id}, callback

module.exports = Role
