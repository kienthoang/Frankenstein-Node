request = require "request"
moment = require "moment"

Actor = require './models/actor'
Crew = require './models/crew'
Event = require './models/event'
Responsibility = require './models/responsibility'
Role = require './models/role'
Stage = require './models/stage'

######################## Import actors ########################

# Send a post request to get the actors data.
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=%5B__actors__%5D', (error, response, actorsJsonData) ->
  console.log 'Data: ' + actorsJsonData

  # Process the actors data.
  actorsData = JSON.parse actorsJsonData
  for actor in actorsData.__actors__
    Actor.createNewActor actor[0], actor[1], (err, actor) ->
      if error?
        console.log 'Error while creating actor ' + actor + ': ' + err


######################## Import crew ########################
# Send a post request to get the crew data.
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=%5B__crew__%5D', (error, response, crewJsonData) ->
  console.log 'Data: ' + crewJsonData

  # Process the crew data.
  crewData = JSON.parse crewJsonData
  for crew in crewData.__crew__
    Crew.createNewCrew crew[0], crew[1], (err, crew) ->
      if error?
        console.log 'Error while creating crew ' + crew + ': ' + err


######################## Import stages ########################
# Send a post request to get the stages data.
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=%5B__stages__%5D', (error, response, stagesJsonData) ->
  console.log 'Data: ' + stagesJsonData

  # Process the stages data.
  stagesData = JSON.parse stagesJsonData
  for stage in stagesData.__stages__
    Stage.createNewStage stage[0], stage[1], (err, stage) ->
      if error?
        console.log 'Error while creating stage ' + stage + ': ' + err


######################## Import roles ########################
# Send a post request to get the roles data.
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=%5B__roles__%5D', (error, response, rolesJsonData) ->
  console.log 'Data: ' + rolesJsonData

  # Process the roles data.
  rolesData = JSON.parse rolesJsonData
  for role in rolesData.__roles__
    Role.createNewRole role[0], role[1], (err, role) ->
      if error?
        console.log 'Error while creating role ' + role + ': ' + err


######################## Import responsibilities ########################
# Send a post request to get the roles data.
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=%5B__responsibilities__%5D', (error, response, respsJsonData) ->
  console.log 'Data: ' + respsJsonData

  # Process the roles data.
  respsData = JSON.parse respsJsonData
  for resp in respsData.__responsibilities__
    Responsibility.createNewResponsibility resp[0], resp[1], (err, resp) ->
      if error?
        console.log 'Error while creating responsibility ' + resp + ': ' + err


######################## Import events ########################
# Send a post request to get the events data.
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=[mangoevents]', (error, response, eventsJsonData) ->
  console.log 'Data: ' + eventsJsonData

  # Process the roles data.
  eventsData = JSON.parse eventsJsonData
  for id, eventData of eventsData
    Event.create {}, (err, eventObj) ->
      eventObj.name = eventData[0]
      eventObj.psql_id = id
      eventObj.description = eventData[1]
      eventObj.duration = eventData[2]
      eventObj.stage_psql_id = eventData[3]
      eventObj.time = moment eventData[4]
      eventObj.actors = eventData[5]
      eventObj.save (err) ->
        unless err?
          console.log 'New event: ' + eventObj
