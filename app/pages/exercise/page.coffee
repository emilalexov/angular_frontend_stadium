define [
  'pages/base/page'
  './template'
  'models/exercise'
  'features/exercise/overview/view'
  'features/exercise/edit/view'
  'features/video/assignment/view'
], (
  BasePage
  template
  Exercise
  ExerciseOverviewView
  ExerciseEditView
  VideoAssignmentView
) ->

  class Page extends BasePage

    behaviors:
      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')
        editable: false

      redirect_back_on_destroy:
        model: ->
          @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      user = App.request('current_user')
      user.exercises.get(@options.id) || new Exercise(id: @options.id)

    initViews: ->
      overview: ->
        view = new ExerciseOverviewView
          model: @model.get('data.model')
        view.listenTo view, 'exercise:edit', =>
          @_changeState('edit')
        view

      edit: ->
        view = new ExerciseEditView
          model: @model.get('data.model')
        view.listenTo view, 'exercise:saved', =>
          @_changeState('overview')
        view

    _changeState: (state) ->
      @model.set('state.subpage', state)
      path = ['exercises', @options.id, state]
      App.vent.trigger('redirect:to', path, trigger: false, replace: false)