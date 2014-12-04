$ ->
  $(document).on 'click', '.submit-actor-create', (e) ->
    $.ajax
      type: 'POST'
      url: '/admin/actors/create'
      data: name: $('.actor-name-input').val()
      success:
        window.location.href = '/admin/actors'
