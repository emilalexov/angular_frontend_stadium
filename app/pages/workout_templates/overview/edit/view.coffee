define [
  './template'
  'features/workout_exercises/view'
  'features/personal_workout_exercises/view'
  'autosize'
], (
  template
  WorkoutExercisesView
  ReadableWorkoutExercisesView
  autosize
) ->

  class WorkoutOverviewView extends Marionette.LayoutView

    key: 'WorkoutOverviewView'

    template: template

    className: 'gc-box-content workout-template edit'

    behaviors: ->
      video_assigned: true
      delete_button:
        enabled: @_enabled
        short: true

      stickit:
        bindings:
          'input': 'name'
          'textarea': 'description'
          '.btn.save':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) ->
                  "#workout_templates/#{id}/overview"
            ]
    ui:
      description: 'textarea'

    events:
      'click .btn.save': '_saveOnExit'

    _attrs: ['name', 'description']

    _enabled: ->
      can('update', @view.options.model)

    initialize: ->
      @oldAttrs = @model.pick(@_attrs...)
      @listenTo(@, 'childview:video:assign', @_videoAssign)

    onShow: ->
      autosize(@ui.description)

    onBeforeDestroy: ->
      isChanged = _.some(@oldAttrs, (val, key) => @model.get(key) isnt val)
      return unless isChanged
      @_saveOnExit() if confirm('Save your data before you leave this page?')

    onDestroy: ->
      autosize.destroy(@ui.description)
      @model.set(@oldAttrs, silent: true)

    _saveOnExit: ->
      @oldAttrs = @model.pick(@_attrs...)
      @model.save()

    _videoAssign: ->
      App.request('modal:video:assign', @model)
