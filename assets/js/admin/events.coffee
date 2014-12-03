$ ->
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
      data.times.push {eventId, time}

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
