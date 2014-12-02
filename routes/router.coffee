passport = require 'passport'

module.exports = (app) ->
  app.get '/login', (req, res) ->
    res.render 'login' 
    
  app.get '*', (req, res) ->
    if not req.user?
      res.redirect '/login'

  app.get '/', (req, res) ->
    res.render 'index', { title: 'Express' }

  app.post '/login', passport.authenticate('local'), (req, res) ->
    res.redirect '/'
