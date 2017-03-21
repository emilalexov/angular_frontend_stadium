define [
  'locales/en'
  'backbone-nested'
], (
  localeData
) ->

  _.templateSettings.interpolate = /\{\{(.+?)\}\}/g

  class LocaleModel extends Backbone.NestedModel

    explain: (key, attrs = {}) ->
      path = ['explain', key].join('.')
      string = locale.get(path)
      re = /^(?:\[(\w)\] )*(.*)$/mi
      match = string.match(re)
      template = match[2]
      message = _.template(template)(attrs)

      message: message
      type: @_getType(match[1])

    _getType: (key) ->
      {
        s: 'success'
        e: 'error'
        i: 'info'
      }[key] || 'info'

  locale = new LocaleModel(localeData)

  ->
    locale.explain(arguments...)
