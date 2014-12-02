User = require '../models/user'

passport = require 'passport'

module.exports = (app) ->
  app.renderViewWithLayout = (res, view, locals= {}) ->
    res.render view, locals, (err, html) ->
      res.locals.content = html
      res.render "layout", (err, html) ->
        res.send html

  app.get '/login', (req, res) ->
    console.log '>>>>>>>>>> error: ' + req.flash('error')
    app.renderViewWithLayout res, 'login'

  app.post '/login', passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }), (req, res) ->
    res.redirect '/'

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/login'
  
  app.all '*', (req, res, next) ->
    if not req.user?
      res.redirect '/login'
    else
      console.log 'Passed authentication!!!!' + req.user
      next()

  app.get '/', (req, res) ->
    app.renderViewWithLayout res, 'index', { title: 'Express' }
