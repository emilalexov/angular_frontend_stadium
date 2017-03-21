define [
  'pages/base/page'
  './template'
  'models/personal_workout'
  './overview/view'
], (
  BasePage
  template
  PersonalWorkout
  OverviewView
) ->

  class Page extends BasePage

    behaviors: ->

      navigate_back: true

      print_button: true

      breadcrumbs:
        model: -> @view.model.get('data.model')

      mobile_only_features: true

      enter_results_for_new_workout_event:
        id: => @options.id

      stickit:
        model: ->
          @model.get('data.model')
        bindings:
          'button[data-action="edit"]':
            observe: 'id'
            visible: ->
              can('update', @model.get('data.model'))

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    events:
      'click button[data-action="edit"]': (ev) ->
        model = @model.get('data.model')
        App.request 'modal:confirm',
          title: "Edit #{model.get('name')}?"
          content:
            '''Changes will be saved immediately
            as soon as you move to the next field.'''
          confirmBtn: 'Update'
          confirmCallBack: ->
            path = ['personal_workouts', model.id, 'edit']
            App.vent.trigger('redirect:to', path, replace: false)


    init: ->
      @_redirectToEditIfEmpty()

    initModel: ->
      new PersonalWorkout
        id: @options.id

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')

    _redirectToEditIfEmpty: ->
      model = @model.get('data.model')
      @listenToOnce model, 'sync', ->
        if can('update', model) and model.exercises.isEmpty()
          App.request('messenger:explain', 'personal_workout.empty')
          path = ['personal_workouts', model.id, 'edit']
          App.vent.trigger('redirect:to', path)
