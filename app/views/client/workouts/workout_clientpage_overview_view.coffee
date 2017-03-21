WorkoutGlobalExercisesView =
  require 'views/client/workouts/workout_clientpage_exercises_view'
WorkoutExercises = require 'collections/workout_exercises'

module.exports = class WorkoutGlobalOverviewView extends Marionette.LayoutView

  template: require('templates/client/workouts/workout_clientpage_overview.hbs')

  className: 'gc-box-content'

  regions:
    exercisesListRegion: '#gc-exercises-list-region'

  templateHelpers: =>
    hasNote: !!@model.get 'note'
    hasDescription: !!@model.get 'description'

  initialize: (data) ->
    @collection = new WorkoutExercises
    @collection.set @model.get('exercises')

    @exercisesView = new WorkoutGlobalExercisesView
      collection: @collection,
      model: @model

    App.vent.on 'workout:notes:add', @showAddNote, @

  onShow: ->
    @exercisesListRegion.show @exercisesView

  onDestroy: ->
    App.vent.off 'workout:notes:add', @showAddNote
