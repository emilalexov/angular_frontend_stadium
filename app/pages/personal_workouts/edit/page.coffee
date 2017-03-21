define [
  'pages/base/page'
  './template'
  'models/personal_workout'
  'pages/workout_templates/overview/overview/view'
], (
  BasePage
  template
  PersonalWorkout
  EditView
) ->

  class Page extends BasePage

    behaviors: ->

      breadcrumbs:
        model: ->
          @view.model.get('data.model')

      navigate_back: true

      mobile_only_features: true

      enter_results_for_new_workout_event:
        id: => @options.id

      stickit:
        model: ->
          @model.get('data.model')
        bindings:
          '.buttons a':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: (id) ->
                  "#personal_workouts/#{id}"
            ]

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new PersonalWorkout
        id: @options.id

    initViews: ->
      edit: ->
        new EditView
          model: @model.get('data.model')
