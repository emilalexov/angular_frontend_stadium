define [
  './template'
  'features/video/assignment/view'
], (
  template
  VideoAssignmentView
) ->

  class WorkoutVideoAssignView extends Marionette.LayoutView

    template: template

    behaviors:
      regioned:
        views: [
            region: 'video-assign-sec'
            klass: VideoAssignmentView
            options: ->
              className: 'modal-video-assign-sec'
              model: @model
              type: @options.type
              instantSave: @options.instantSave
        ]
