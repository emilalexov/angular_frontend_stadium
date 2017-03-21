define [
  'pages/base/page'
  './template'
  'models/program_template'
  'features/assignment_list/view'
  './overview/view'
], (
  BasePage
  template
  ProgramTemplate
  AssignView
  OverviewView
) ->

  class Page extends BasePage

    behaviors: ->

      navigate_back: true

      breadcrumbs:
        model: ->
          @view.model.get('data.model')

      navigation_content_tabs:
        data: [
            id: 'overview'
            title: 'Overview'
          ,
            id: 'assign'
            title: 'Assign'
        ]

      program_action_panel:
        model: -> @view.model.get('data.model')
        readonly: ->
          !@_canUpdateModel()

      add_to_library:
        model: -> @view.model.get('data.model')

      actions_dropdown:
        model: -> @view.model.get('data.model')
        items: [
            label: 'Add Note'
            visible: _.bind(@_canUpdateModel, @)
          ,
            label: 'Print'
            action: @_print
          ,
            label: 'Add To Library'
            visible: _.bind ->
                authorId = @model.get('data.model').get('author_id')
                authorId isnt App.request('current_user_id')
              ,
                @
            action: @_onAddToLibrary
          ,
            label: 'Delete'
            className: 'text-danger'
            action: ->
              App.request('modal:confirm:delete', @model)
            visible: _.bind(@_canUpdateModel, @)
        ]

      redirect_back_on_destroy:
        model: -> @view.model.get('data.model')

      stickit:
        bindings:
          '.gc-nav-wrapper:last':
            observe: 'state.subpage'
            visible: (value) -> value is 'overview'

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      @model.set('state.subpage', @options.state)

    initModel: ->
      user = App.request('current_user')
      program_template = user.program_templates.get(@options.id)
      program_template || new ProgramTemplate(id: @options.id)

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
      assign: ->
        new AssignView
          model: @model.get('data.model')

    onShow: ->
      dataModel = @model.get('data.model')
      @listenTo(dataModel, 'change:user_id', @_changeContentTabsVisibility)

    _canUpdateModel: ->
      can('update', @model.get('data.model'))

    _changeContentTabsVisibility: ->
      if @_canUpdateModel()
        @navigation_content_tabs.$el.show()
      else
        @navigation_content_tabs.$el.hide()

    _onAddToLibrary: ->
      App.request 'base:addToLibraryModal',
        model: @model
        type: 'Program Templates'

    _print: ->
      window.print()
