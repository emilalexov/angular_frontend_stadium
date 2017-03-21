define [
  'deps/bundles/backbone/bundle'
], (
  Backbone
) ->

  ->

    occurrences = (string, subString, allowOverlapping) ->
      string += ''
      subString += ''
      return string.length + 1  if subString.length <= 0
      n = 0
      pos = 0
      step = (if (allowOverlapping) then (1) else (subString.length))
      loop
        pos = string.indexOf(subString, pos)
        if pos >= 0
          n += 1
          pos += step
        else
          break
      n

    _.extend Backbone.Validation.callbacks,
        valid: (view, attr, selector) ->
          $inputGroup = view.$el.find("[name=#{attr}]").closest('.form-group')
          $inputGroup.removeClass('gc-invalid').addClass('gc-valid')
          $inputGroup.find('.gc-valid-icon').removeClass('hide')
          $inputGroup.find('.gc-error-message').text('')

        invalid: (view, attr, error, selector) ->
          $inputGroup = view.$el.find("[name=#{attr}]").closest('.form-group')
          $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
          $inputGroup.find('.gc-valid-icon').addClass('hide')
          $inputGroup.find('.gc-error-message').text(error)

    _.extend Backbone.Validation.validators,
      isFloat: (value, attr, customValue, model) ->
        if value
          value = value.replace(/\,/g, '.')
          if occurrences(value, '.') > 1
            return 'error'
          if value.match(/^[0-9\.]+$/) is null
            return 'error'
          if not parseFloat value
            return 'error'
