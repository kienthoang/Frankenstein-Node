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
request 'http://tomcat.cs.lafayette.edu:3000/mongopie/?types=%5B__events__%5D', (error, response, eventsJsonData) ->
  eventsJsonData = '{
 "1": ["the start of the study", "Victor meets Professor Waldman, who encourages Victor to pursue his studies of Cornelius Agrippa, despite Professor Krempes mocking of the subject.", 5, 2, "2015-04-22 20:00:00", [{"actor_id": 4, "role_id": 15}, {"actor_id": 46, "role_id": 13}, {"actor_id": 43, "role_id": 12}, {"actor_id": 44, "role_id": 1}]],

 "2": ["the creation of the monster", "Victor creates the monster from dead peoples bodyparts, and is horrified at the sight of him, especially in the creatures lifeless eyes. When the monster tries to reach out to hug Victor, Victor rejects and abandons the monster, showing him hate from the minute he was made.", 15, 1, "2015-04-22 20:05:00", [{"actor_id": 24, "role_id": 3}, {"actor_id": 1, "role_id": 2}, {"actor_id": 6, "role_id": 1}]],

 "3": ["the first murder", "The monster kills William and blames the murder on Justine. This causes Victor and his family great pain and anguish.", 5, 3, "2015-04-22 20:20:00", [{"actor_id": 56, "role_id": 6}, {"actor_id": 47, "role_id": 4}, {"actor_id": 38, "role_id": 8}, {"actor_id": 42, "role_id": 7}, {"actor_id": 13, "role_id": 5}, {"actor_id": 2, "role_id": 2}, {"actor_id": 28, "role_id": 1}]],

 "4": ["the story of the monster part one", "Victor agrees to listen to the monsters story and the monster tells him of how he was rejected from a family whose love he desired. He then burns down their house out of anger.", 5, 2, "2015-04-22 20:25:00", [{"actor_id": 12, "role_id": 10}, {"actor_id": 46, "role_id": 9}, {"actor_id": 3, "role_id": 2}, {"actor_id": 20, "role_id": 1}]],

 "5": ["the story of the monster part two", "The monster tells Victor that he was shot after he saved a little girl from drowning in a river. The monster then swears eternal hatred and vengeance to all mankind.", 10, 4, "2015-04-22 20:30:00", [{"actor_id": 15, "role_id": 15}, {"actor_id": 4, "role_id": 15}, {"actor_id": 38, "role_id": 11}, {"actor_id": 56, "role_id": 10}, {"actor_id": 43, "role_id": 9}, {"actor_id": 4, "role_id": 2}]],

 "6": ["the request from the monster", "The monster asks Victor to create him a female creature like him, and then he will leave Europe forever. Victor agrees to do this.", 5, 4, "2015-04-22 20:40:00", [{"actor_id": 5, "role_id": 2}, {"actor_id": 57, "role_id": 1}]],

 "131": ["the secret", "Victor writes to Elizabeth and promises her to tell her his secret about the monster on the day after their wedding has taken place.", 5, 2, "2015-04-24 21:40:00", [{"actor_id": 18, "role_id": 5}, {"actor_id": 13, "role_id": 1}]],

 "132": ["the secret", "Victor writes to Elizabeth and promises her to tell her his secret about the monster on the day after their wedding has taken place.", 5, 2, "2015-04-24 21:55:00", [{"actor_id": 58, "role_id": 5}, {"actor_id": 30, "role_id": 1}]]
}'
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
      console.log 'New event: ' + eventObj
