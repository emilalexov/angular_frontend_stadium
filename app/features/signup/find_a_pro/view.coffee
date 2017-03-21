define [
  './template'
  '../pro_invite/model'
  '../behavior'
], (
  template
  Model
  AuthBodyClassBehavior
) ->

  class FindProView extends Marionette.ItemView

    template: template

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior

    initialize: ->
      model = new Model
      model.request()
