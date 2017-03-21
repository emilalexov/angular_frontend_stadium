define ->

  class CompletionRingModel extends Backbone.Model

    type: 'CompletionRingModel'

    defaults:
      completed: 0
      total: 0
      description: ''
      progress_max: 20

    computed: ->
      name:
        depends: [
          'completed'
          'total'
        ]
        get: (attrs) ->
          return @get(@get('customName')) if @get('customName')
          "#{attrs.completed}/#{attrs.total}"
        toJSON: false
      progress:
        depends: [
          'completed'
          'total'
          'progress_max'
        ]
        get: (attrs) ->
          percentage = (attrs.completed / attrs.total) or 0
          value = percentage * attrs.progress_max
          parseInt(value, 10)
        toJSON: false

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)
