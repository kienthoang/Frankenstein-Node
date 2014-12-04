$ ->
  selectedEventId = ''
  $('.events-select').on 'change', (e) ->
    selectedEventId = $(this).val()
    $editSpace = $('.event-edit-space')
    $editSpace.attr 'data-eventId', selectedEventId

    # Load the event edit space.
    $.ajax
      type: 'GET'
      url: '/admin/events/' + selectedEventId
      success: (editSpace) ->
        $editSpace.html editSpace

  $(document).on 'click', '.event-time-modal-controller', (e) ->
    $(this).next('.event-time-modal').modal()

  $(document).on 'click', '.submit-event-edit', (e) ->
    data =
      name: $('.event-name-input').val()
      times: []
      newTimes: []
    
    $('.event-time-row').each ->
      eventId = $(this).attr 'data-id'
      time = $(this).find('.event-date-input').val() + ' ' + $(this).find('.event-time-input').val()
      toBeDeleted = $(this).find('.event-deletion-checkbox').is ':checked'
      data.times.push {eventId, time, toBeDeleted}

    $('.new-event-time-row').each ->
      dateVal = $(this).find('.event-date-input').val()
      timeVal = $(this).find('.event-time-input').val()
      if dateVal and timeVal
        time = dateVal + ' ' + timeVal
        data.newTimes.push time

    $.ajax
      type: 'POST'
      url: '/admin/events/' + $('.events-select').val() + '/edit'
      contentType: 'application/json'
      data: JSON.stringify data
      success: ->
        window.location.href = '/admin/events'

  $(document).on 'click', '.add-event-button', (e) ->
    $newEventRow = $('.prototype-new-event-time-row').clone()
    $newEventRow.appendTo $('.event-times-rows')
    $newEventRow.removeClass('prototype-new-event-time-row').addClass 'new-event-time-row'

  $(document).on 'click', '.add-actor-role-button', (e) ->
    $modal = $(this).closest '.event-time-modal'
    $newActorRoleRow = $modal.find('.prototype-actor-role-selection').clone()
    $newActorRoleRow.removeClass('prototype-actor-role-selection').addClass 'actor-role-selection'
    $newActorRoleRow.insertBefore $(this)

  $(document).on 'click', '.save-actor-role-changes', (e) ->
    actorRoles = []
    $modal = $(this).closest '.event-time-modal'
    $modal.find('.actor-role-selection').each ->
      shouldBeIncluded = not $(this).find('.actor-role-removal').is ':checked'
      if shouldBeIncluded
        actorRoles.push
          actor_id: $(this).find('.actor-select-menu').val()
          role_id: $(this).find('.role-select-menu').val()
      else
        $(this).remove()

    eventId = $(this).closest('.event-time-row').attr 'data-id'
    $.ajax
      type: 'POST'
      url: '/admin/events-actors-roles/' + eventId
      contentType: 'application/json'
      data: JSON.stringify {actorRoles}

  $(document).on 'click', '.delete-event-button', (e) ->
    alert '/admin/events/' + selectedEventId + '/delete'
    $.ajax
      type: 'POST'
      url: '/admin/events/' + selectedEventId + '/delete'
      success: ->
        window.location.href = '/admin/events'

  $(document).on 'click', '.create-new-event', (e) ->
    
