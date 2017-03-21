define ->

  class UserSettings extends Backbone.Model

    type: 'UserSettings'

    urlRoot: '/user_settings'

    defaults:
      id: undefined
      user_id: undefined
      user_account_type_id: undefined
      user_account_type_name: ''
      units_system: 'imperial'
      is_tutorial_finished: false
      is_presets_loaded: false
      client_title: ''
      tutorial_steps: []

    computed: ->
      clients_title:
        depends: ['user_account_type_name']
        get: (attrs) ->
          {
            'Physical Therapist': 'Patients'
            'Coach': 'Athletes'
            'Athletic Trainer': 'Athletes'
            'Personal Trainer': 'Clients'
          }[attrs['user_account_type_name']] || 'Clients'
        toJSON: false

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)