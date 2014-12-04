$ ->
  $('.roles-select').on 'change', (e) ->
    selectedRoleId = $(this).val()
    $editSpace = $('.role-edit-space')
    $editSpace.attr 'data-roleId', selectedRoleId

    # Load the event edit space.
    $.ajax
      type: 'GET'
      url: '/admin/roles/' + selectedRoleId
      success: (editSpace) ->
        $editSpace.html editSpace

  $(document).on 'click', '.submit-role-edit', (e) ->
    data = name: $('.role-name-input').val()
    $.ajax
      type: 'POST'
      url: '/admin/roles/' + $('.roles-select').val() + '/edit'
      contentType: 'application/json'
      data: JSON.stringify data
      success: ->
        window.location.href = '/admin/roles'

  $(document).on 'click', '.delete-role-button', (e) ->
    $.ajax
      type: 'POST'
      url: '/admin/roles/' + $('.roles-select').val() + '/delete'
      contentType: 'application/json'
      success: ->
        window.location.href = '/admin/roles'
