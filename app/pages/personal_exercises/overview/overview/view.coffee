define [
  './template'
  'features/personal_best/view'
], (
  template
  PersonalBest
) ->

  class ExerciseOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors:
      author_widget: true
      editable_textarea: true
      video_assigned: true

      regioned:
        views: [
            region: 'personal_best'
            klass: PersonalBest
            options: ->
              exercise: @model
              user: @options.user
        ]
