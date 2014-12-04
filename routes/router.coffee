Actor = require '../models/actor'
Event = require '../models/event'
Role = require '../models/role'
User = require '../models/user'

require 'sugar'
moment = require 'moment'
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
            event.times.push
              event_id: e.id
              original: e.time
              date: moment(e.time).format 'YYYY-MM-DD'
              time: moment(e.time).format 'HH:mm'
            console.log 'Time: ' + e.time + ' compared to ' + moment(e.time).format 'HH:mm'
            event.actorsByTimes[e.time] = e.actors.map (actorRole) ->
              actorRole =
                actor: actorsMap[actorRole.actor_id]
                role: rolesMap[actorRole.role_id]
              return actorRole
              
          res.render 'admin/event-edit',
            event: event
            actors: actors
            roles: roles


  app.post '/admin/events/:id/edit', (req, res) ->
    newName = req.body.name
    times = req.body.times
    timesMap = {}
    for time in times
      timesMap[time.eventId] =
        toBeDeleted: time.toBeDeleted
        time: time.time

    Event.findByPsqlId req.params.id, (err, events) ->
      for event in events
        unless timesMap[event.id].toBeDeleted
          event.name = newName
          event.time = moment(timesMap[event.id].time).toDate()
      for event in events
        if timesMap[event.id].toBeDeleted
          Event.findByIdAndRemove event.id, (err) -> console.log 'Deleted!'
        else
          event.save (err) -> console.log 'Saved!'

      for newEventTime in req.body.newTimes
        do (newEventTime) ->
          newEvent =
            name: events[0].name
            description: events[0].description
            duration: events[0].duration
            psql_id: events[0].psql_id
            stage_psql_id: events[0].stage_psql_id
            time: moment(newEventTime).toDate()
          Event.create newEvent, (err, nE) -> console.log 'Error: ' + err if err?

      res.send 'OK'


  app.post '/admin/events-actors-roles/:eid', (req, res) ->
    Event.findById req.params.eid, (err, event) ->
      event.actors = req.body.actorRoles
      event.markModified 'actors'
      event.save (err) ->
        console.log 'Success!' unless err?
        res.send "OK"
