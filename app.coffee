express = require 'express'
path = require 'path'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

# Express application.
app = express()

module.exports = () ->
  # view engine setup
  app.set('views', path.join(__dirname, 'views'));
  app.set('view engine', 'jade');

  # Parsers setup.
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: false }));
  app.use(cookieParser());
  app.use(express.static(path.join(__dirname, 'public')));

  # Routing.
  require('./routes/router.coffee')(app)

  # Run the server
  server = app.listen 3000, () ->
    host = server.address().address
    port = server.address().port

    console.log 'Frankenstein app running at http://%s:%s', host, port
