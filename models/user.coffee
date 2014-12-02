mongoose = require "mongoose"

# Create a user schema
UserSchema = new mongoose.Schema
  name:
    first: String
    last: String
    full: String
  email: String
  password: String

# Return User model
User = mongoose.model "User", UserSchema
User.findUser = (email, password, callback) ->
  condition =
    email: email
    password: password
  @findOne condition, callback

module.exports = User
