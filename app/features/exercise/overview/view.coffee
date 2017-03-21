define [
  './template'
], (
  template
) ->

  class ExerciseOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content gc-exercise-wrapper'

    behaviors:
      author_widget: true
      privacy_widget: true
      video_assigned:
        controls: false
      textarea_autosize: true
      stickit:
        bindings:
          '.gc-exercise-description': 'description'

    ui:
      edit: '.gc-edit-exercise'

    triggers:
      'click @ui.edit': 'exercise:edit'