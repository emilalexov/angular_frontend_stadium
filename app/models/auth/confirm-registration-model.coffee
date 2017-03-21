define ->

  class ConfirmRegistrationModel extends Backbone.Model

    url: '/users/confirmation'

    validation:

      confirmation_token:
        required: true

    confirm: (token) ->

      options =
        url: @url
        type: 'GET'
        contentType: 'application/json'
        data: $.param(confirmation_token: token)

      (@sync || Backbone.sync).call(@, null, @, options)
        .then (response) =>
          @trigger 'model:auth_confirm:success', response
        .fail (xhr, textStatus, errorThrown) =>
          @trigger 'model:auth_confirm:fail'
