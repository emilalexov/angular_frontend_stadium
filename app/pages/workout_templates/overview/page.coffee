define [
  'pages/base/page'
  './template'
  'models/workout_template'
  'features/assignment_list/view'
  './overview/view'
  './edit/view'
], (
  BasePage
  template
  WorkoutTemplate
  AssignView
  OverviewView
  EditView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')
        editable: false

      navigation_content_tabs:
        data: [
            id: 'overview'
            title: 'Overview'
          ,
            id: 'assign'
            title: 'Assign'
        ]

      redirect_back_on_destroy:
        model: -> @view.model.get('data.model')

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      user = App.request('current_user')
      workout_template = user.workout_templates.get(@options.id)
      workout_template || new WorkoutTemplate(id: @options.id)

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
      edit: ->
        new EditView
          model: @model.get('data.model')
      assign: ->
        new AssignView
          model: @model.get('data.model')

    onShow: ->
      dataModel = @model.get('data.model')
      @listenTo(dataModel, 'change:user_id', @_changeContentTabsVisibility)

    _changeContentTabsVisibility: ->
      if can('update', @model.get('data.model'))
        @navigation_content_tabs.$el.show()
      else
        @navigation_content_tabs.$el.hide()
