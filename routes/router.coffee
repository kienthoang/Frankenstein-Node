passport = require 'passport'

module.exports = (app) ->
  app.renderViewWithLayout = (res, view, locals= {}) ->
    res.render view, locals, (err, html) ->
      res.locals.content = html
      res.render "layout", (err, html) ->
        console.log "Error: " + err
        res.send html

  app.get '/login', (req, res) ->
    app.renderViewWithLayout res, 'login' 

  app.get '*', (req, res) ->
    if not req.user?
      res.redirect '/login'

  app.get '/', (req, res) ->
    res.render 'index', { title: 'Express' }

  app.post '/login', passport.authenticate('local'), (req, res) ->
    res.redirect '/'
