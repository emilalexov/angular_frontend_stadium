define [
  './template'
  './model'
  './user_account_type/view'
  './program_presets_select/view'
  './finish/view'
], (
  template
  Model
  UserAccountTypeView
  ProgramPresetModalView
  FinishModalView
) ->

  class PresetLoadModalView extends Marionette.LayoutView

    template: template

    regions:
      modal: 'region[data-name="presets_load_modal"]'

    availableViews:
      user_account_type: UserAccountTypeView
      program_presets_select: ProgramPresetModalView
      finish: FinishModalView

    initialize: ->
      @model = new Model
      @listenTo(@model, 'change:state', @_renderRegionView)

    onRender: ->
      @_renderRegionView(@model, @model.get('state'))

    _renderRegionView: (_model, state) ->
      @stopListening(@view) if @view

      View = @availableViews[state] || @availableViews['user_account_type']
      @view = new View
      @getRegion('modal').show(@view)

      @listenTo(@view, 'changeView', @_changeView)
      @listenTo(@view, 'modal:closed', @_closeModal)

    _changeView: (direction) ->
      states = _.keys(@availableViews)
      index = _.indexOf(states, @model.get('state'))
      switch direction
        when 'next'
          newState = states[index + 1] || _.last(states)
        when 'prev'
          newState = states[index - 1] || _.first(states)
        else
          # check your direction of the changing view
      @model.set(state: newState)

    _closeModal: ->
      @trigger('modal:closed')
