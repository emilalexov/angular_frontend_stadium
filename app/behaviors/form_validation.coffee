define ->

  class FormValidationBehavior extends Marionette.Behavior

    key: 'form_validation'

    initialize: ->
      @listenTo(@view, 'switchError', @_switchError)

    _switchError: (error_msg, $inputGroup) ->
      if error_msg
        $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
        $inputGroup.find('.gc-valid-icon').addClass('hide')
        $inputGroup.find('.gc-error-message').text(error_msg)
      else
        $inputGroup.removeClass('gc-invalid').addClass('gc-valid')
        $inputGroup.find('.gc-valid-icon').removeClass('hide')
        $inputGroup.find('.gc-error-message').text('')
