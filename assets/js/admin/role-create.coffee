$ ->
  $(document).on 'click', '.submit-role-create', (e) ->
    $.ajax
      type: 'POST'
      url: '/admin/roles/create'
      data: name: $('.role-name-input').val()
      success:
        window.location.href = '/admin/roles'
