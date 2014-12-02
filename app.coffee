express = require 'express'
path = require 'path'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

mongoose = require 'mongoose'
passport = require 'passport'

flash = require 'connect-flash'
session = require 'cookie-session'

# Express application.
app = express()

# Run mongodb
mongoose.connect "mongodb://localhost/frankenstein"

User = require './models/user'

passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

passport.serializeUser (user, done) ->
  console.log 'Serialize: ' + user.id
  done null, user.id

passport.deserializeUser (id, done) ->
  console.log 'Unserialize id ' + id
  User.findById id, (err, user) ->
    done err, user

# Create users
User.find {}, (err, users) ->
  unless users.length
    admin =
      name:
        first: 'Adam'
        last: 'Frankenstein'
        full: 'Adam Frankenstein'
      email: 'adamfrankenstein@monster.com'
      password: '123'
    User.create admin, (err, user) ->
      console.log 'Created admin successfully!'

passport.use new LocalStrategy((email, password, done) ->
  console.log 'Trying to login: ' + email + ' - ' + password
  User.findUser email, password, (err, user) ->
    if err
      return done err
    if not user?
      return done null, false, { message: 'Incorrect username.' }

    userInfo =
      id: user.id
      username: user.email
      password: user.password

    console.log 'Login successfully: ' + userInfo.id
    return done null, userInfo
)

module.exports = () ->
  # view engine setup
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');

  # Parsers setup.
  app.use bodyParser.json()
  app.use bodyParser.urlencoded({ extended: false })
  app.use cookieParser()
  app.use session(
    keys: ['key1', 'key2']
  )
  app.use express.static(path.join(__dirname, 'public'))
  app.use flash()
  app.use passport.initialize()
  app.use passport.session()

  app.use require("connect-assets")() 

  # Routing.
  require('./routes/router.coffee')(app)

  # Run the server
  server = app.listen 3000, () ->
    host = server.address().address
    port = server.address().port

    console.log 'Frankenstein app running at http://%s:%s', host, port   
