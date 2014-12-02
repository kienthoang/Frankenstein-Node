require 'sugar'

Actor = require '../models/actor'
Event = require '../models/event'
Role = require '../models/role'
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

  app.get '/admin/events', (req, res) ->
    events = Event.find {}, (err, events) ->
      # Aggregate the events by their psql_id
      eventsMap = {}
      for event in events
        eventsMap[event.psql_id] = event
      events = Object.values eventsMap
      events = events.sortBy (event) -> event.name
      app.renderViewWithLayout res, 'admin/events', {events}

  app.get '/admin/events/:id', (req, res) ->
    Actor.find {}, (err, actors) ->
      actorsMap = {}
      for actor in actors
        actorsMap[actor.psql_id] = actor
      Role.find {}, (err, roles) ->
        rolesMap = {}
        for role in roles
          rolesMap[role.psql_id] = role

        Event.findByPsqlId req.params.id, (err, events) ->
          # Aggregate the events into a psql-original event.
          event = events[0]
          event.times = []
          event.actorsByTimes = {}
          for e in events
            event.times.push e.time
            event.actorsByTimes[e.time] = e.actors.map (actorRole) ->
              actorRole =
                actor: actorsMap[actorRole.actor_id]
                role: rolesMap[actorRole.role_id]
              return actorRole
              
          res.render 'admin/event-edit', {event}
