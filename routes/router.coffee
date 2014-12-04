Actor = require '../models/actor'
Event = require '../models/event'
Role = require '../models/role'
User = require '../models/user'

require 'sugar'
moment = require 'moment'
passport = require 'passport'
request = require 'request'

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
    Event.find {}, (err, events) ->
      # Aggregate the events by their psql_id
      eventsMap = {}
      for event in events
        eventsMap[event.psql_id] = event
      events = Object.values eventsMap
      events = events.sortBy (event) -> event.name
      app.renderViewWithLayout res, 'admin/events', {events}

  app.get '/admin/events/create', (req, res) ->
    app.renderViewWithLayout res, 'admin/event-create'

  app.post '/admin/events/create', (req, res) ->
    Event.find {}, (err, events) ->
      psql_id = 1 + parseInt(events.max((e) -> return parseInt(e.psql_id)).psql_id)
      Event.create {event_time_psql_id: 2 + parseInt(events.max((e) -> return parseInt(e.event_time_psql_id)).event_time_psql_id), name: req.body.name, duration: req.body.duration, description: req.body.description, psql_id: psql_id, time: new Date()}, (err, event) ->
        event.save (err) ->
          request 'http://tomcat.cs.lafayette.edu:3300/events/create?id=' + event.psql_id + '&new_name=' + event.name + '&description=' + event.description + '&duration=' + event.duration, ->
            console.log 'Created event: ' + event.name + ' error: ' + err
            newEventTime =
              name: event.name
              times: []
              event_id: event.psql_id
              new_times: [{
                id: 2 + parseInt(events.max((e) -> return parseInt(e.event_time_psql_id)).event_time_psql_id)
                date: moment(event.time).format 'YYYY-MM-DD HH:mm'
              }]
              deleted_times: []
            postData = JSON.stringify(newEventTime).escapeURL()
            request 'http://tomcat.cs.lafayette.edu:3300/events/edit?data=' + postData, ->
              res.send 'OK'

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
            actorRoles = []
            for actorRole in e.actors
              actor = actorsMap[actorRole.actor_id]
              role = rolesMap[actorRole.role_id]
              if actor? and role?
                actorRoles.push {actor, role}
            event.actorsByTimes[e.time] = actorRoles
              
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

    # Sync data. To be sent to the psql database.
    syncData =
        name: newName
        times: []
        event_id: ''
        new_times: []
        deleted_times: []

    Event.find {}, (err, allEventTimes) ->
      Event.findByPsqlId req.params.id, (err, events) ->
        syncData.event_id = events[0].psql_id

        for event in events
          unless timesMap[event.id].toBeDeleted
            event.name = newName
            event.time = moment(timesMap[event.id].time).toDate()
        for event in events
          do (event) ->
            if timesMap[event.id].toBeDeleted
              syncData.deleted_times.push event.event_time_psql_id
              Event.findByIdAndRemove event.id, (err) -> console.log 'Deleted!'
            else
              syncData.times.push
                id: event.event_time_psql_id
                date: timesMap[event.id].time
              event.save (err) -> console.log 'Saved!'

        postData = JSON.stringify(syncData).escapeURL()
        if req.body.newTimes.length == 0
          request 'http://tomcat.cs.lafayette.edu:3300/events/edit?data=' + postData

        for newEventTime in req.body.newTimes
          do (newEventTime) ->
            newEvent =
              name: events[0].name
              description: events[0].description
              duration: events[0].duration
              psql_id: events[0].psql_id
              stage_psql_id: events[0].stage_psql_id
              time: moment(newEventTime).toDate()
              event_time_psql_id: 1 + parseInt(allEventTimes.max((e) -> return parseInt(e.event_time_psql_id)).event_time_psql_id)
            syncData.new_times.push
              id: newEvent.event_time_psql_id
              date: moment(newEvent.time).format 'YYYY-MM-DD HH:mm'
            postData = JSON.stringify(syncData).escapeURL()
            request 'http://tomcat.cs.lafayette.edu:3300/events/edit?data=' + postData
            console.log 'Sending ' + 'http://tomcat.cs.lafayette.edu:3300/events/edit?data=' + postData
            Event.create newEvent, (err, nE) ->
              console.log 'Error: ' + err if err?
              nE.save (err) -> console.log 'Error: ' + err if err?

        res.send 'OK'


  app.post '/admin/events-actors-roles/:eid', (req, res) ->
    Event.findById req.params.eid, (err, event) ->
      event.actors = req.body.actorRoles
      event.markModified 'actors'
      event.save (err) ->
        console.log 'Success!' unless err?
        syncData =
          event_time_id: event.event_time_psql_id
          actorRolePairs: req.body.actorRoles
        postData = JSON.stringify(syncData).escapeURL()
        request 'http://tomcat.cs.lafayette.edu:3300/events/actors-roles-edit?data=' + postData
        res.send "OK"

  app.post '/admin/events/:eid/delete', (req, res) ->
    Event.findByPsqlId req.params.eid, (err, events) ->
      for event in events
        Event.findByIdAndRemove event.id, (err) -> console.log 'Deleted'
      request 'http://tomcat.cs.lafayette.edu:3300/events/delete?id=' + events[0].psql_id, ->
        res.send 'OK'

  app.get '/admin/actors', (req, res) ->
    Actor.find {}, (err, actors) ->
      # Aggregate the actors by their psql_id
      actorsMap = {}
      for actor in actors
        actorsMap[actor.psql_id] = actor
      actors = Object.values actorsMap
      actors = actors.sortBy (actor) -> actor.name
      app.renderViewWithLayout res, 'admin/actors', {actors}

  app.get '/admin/actors/create', (req, res) ->
    app.renderViewWithLayout res, 'admin/actor-create'

  app.post '/admin/actors/create', (req, res) ->
    Actor.find {}, (err, actors) ->
      psql_id = 1 + parseInt(actors.max((a) -> return parseInt(a.psql_id)).psql_id)
      Actor.create {name: req.body.name, psql_id: psql_id}, (err, actor) ->
        actor.save (err) ->
          console.log 'Created actor: ' + actor.name
          request 'http://tomcat.cs.lafayette.edu:3300/actors/create?id=' + actor.psql_id + '&new_name=' + actor.name
          res.send 'OK'

  app.get '/admin/actors/:id', (req, res) ->
    Actor.findByPsqlId req.params.id, (err, actor) ->
      app.renderViewWithLayout res, 'admin/actor-edit', {actor}

  app.post '/admin/actors/:id/edit', (req, res) ->
    Actor.findByPsqlId req.params.id, (err, actor) ->
      actor.name = req.body.name
      actor.save (err) ->
        request 'http://tomcat.cs.lafayette.edu:3300/actors/edit?id=' + actor.psql_id + '&new_name=' + actor.name
        res.send 'OK'

  app.post '/admin/actors/:id/delete', (req, res) ->
    Actor.findByPsqlId req.params.id, (err, actor) ->
      Actor.findByIdAndRemove actor.id, ->
        console.log 'HEY!'
        request 'http://tomcat.cs.lafayette.edu:3300/actors/delete?id=' + actor.psql_id
        res.send 'OK'

  app.get '/admin/roles', (req, res) ->
    Role.find {}, (err, roles) ->
      # Aggregate the roles by their psql_id
      rolesMap = {}
      for role in roles
        rolesMap[role.psql_id] = role
      roles = Object.values rolesMap
      roles = roles.sortBy (actor) -> role.name
      app.renderViewWithLayout res, 'admin/roles', {roles}

  app.get '/admin/roles/create', (req, res) ->
    app.renderViewWithLayout res, 'admin/role-create'

  app.post '/admin/roles/create', (req, res) ->
    Role.find {}, (err, roles) ->
      psql_id = parseInt(roles.max((a) -> return parseInt(a.psql_id)).psql_id) + 1
      Role.create {name: req.body.name, psql_id: psql_id}, (err, role) ->
        role.save (err) ->
          console.log 'Created role: ' + role.name
          request 'http://tomcat.cs.lafayette.edu:3300/roles/create?id=' + role.psql_id + '&new_name=' + role.name
          res.send 'OK'

  app.get '/admin/roles/:id', (req, res) ->
    Role.findByPsqlId req.params.id, (err, role) ->
      app.renderViewWithLayout res, 'admin/role-edit', {role}

  app.post '/admin/roles/:id/edit', (req, res) ->
    Role.findByPsqlId req.params.id, (err, role) ->
      role.name = req.body.name
      role.save (err) ->
        request 'http://tomcat.cs.lafayette.edu:3300/roles/edit?id=' + role.psql_id + '&new_name=' + role.name
        res.send 'OK'

  app.post '/admin/roles/:id/delete', (req, res) ->
    Role.findByPsqlId req.params.id, (err, role) ->
      Role.findByIdAndRemove role.id, ->
        request 'http://tomcat.cs.lafayette.edu:3300/roles/delete?id=' + role.psql_id
        res.send 'OK'
