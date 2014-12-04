$ ->
  $(document).on 'click', '.submit-event-create', (e) ->
    $.ajax
      type: 'POST'
      url: '/admin/events/create'
      data:
      	name: $('.event-name-input').val()
      	duration: $('.event-duration-input').val()
      	description: $('.event-description-input').val()
      success: ->
        window.location.href = '/admin/events'
