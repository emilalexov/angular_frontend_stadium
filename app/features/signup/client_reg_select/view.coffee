define [
  './template'
  './model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class View extends Marionette.ItemView

    template: template

    behaviors: ->

      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

      stickit:
        bindings:
          'input[type="radio"]': 'reg_type'
          'button':
            attributes: [
                name: 'disabled',
                observe: 'reg_type',
                onGet: (value) -> !value
            ]
            classes:
              disabled:
                observe: 'reg_type'
                onGet: (value) -> !value

    events:
      'submit form': '_onTypeSelected'

    initialize: ->
      @model = new Model

    _onTypeSelected: ->
      path = ['auth', @model.get('reg_type')]
      App.vent.trigger('redirect:to', path, replace: false)
