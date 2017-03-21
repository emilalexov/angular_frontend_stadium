define [
  './common'
  './auth'
  './clients'
  './client_groups'
  './dashboard'
  './exercises'
  './folders'
  './other'
  './personal_properties'
  './program_templates'
  './personal_programs'
  './users'
  './workout_templates'
  './personal_workouts'
  './workout_exercises'
  './prototype'
  './old_client_router'
  './payments'
  './video_library'
  './event_results'
  './trainer_certification'
], ->

  modules = _.toArray(arguments)

  class Module extends Marionette.Module

    initialize: ->

      @on 'start', ->
        _.each modules, (module) ->
          module.init()

      Backbone.history.on 'route', (route, params) =>
        @app.reqres.hasHandler('current_user') and
        @app.request('current_user') and
        !_.include(['#payments/info', '#trial_ended'], window.location.hash) and
        @app.request('check:trial')
