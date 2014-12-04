$ ->
  $('.actors-select').on 'change', (e) ->
    selectedActorId = $(this).val()
    $editSpace = $('.actor-edit-space')
    $editSpace.attr 'data-actorId', selectedActorId

    # Load the event edit space.
    $.ajax
      type: 'GET'
      url: '/admin/actors/' + selectedActorId
      success: (editSpace) ->
        $editSpace.html editSpace

  $(document).on 'click', '.submit-actor-edit', (e) ->
    data = name: $('.actor-name-input').val()
    $.ajax
      type: 'POST'
      url: '/admin/actors/' + $('.actors-select').val() + '/edit'
      contentType: 'application/json'
      data: JSON.stringify data
      success: ->
        window.location.href = '/admin/actors'

  $(document).on 'click', '.delete-actor-button', (e) ->
    $.ajax
      type: 'POST'
      url: '/admin/actors/' + $('.actors-select').val() + '/delete'
      contentType: 'application/json'
      success: ->
        window.location.href = '/admin/actors'
