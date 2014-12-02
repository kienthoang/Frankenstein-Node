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
