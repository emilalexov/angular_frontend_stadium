define [
  './template'
  '../behavior'
], (
  template
  AuthBodyClassBehavior
) ->

  class WaitingGymcloudProView extends Marionette.ItemView

    template: template

    behaviors:
      authBodyClass:
        behaviorClass: AuthBodyClassBehavior
