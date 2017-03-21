define [
  './template'
  '../model'
], (
  template
  DataModel
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'program-action-panel'

    behaviors:

      print_button: true

      stickit:
        model: -> @data
        bindings: ->
          highlight = ($el) ->
            $el.addClass('highlight')
            setTimeout (-> $el.removeClass('highlight')), 350

          '.counter.weeks':
            observe: 'weeksCount'
            afterUpdate: highlight
          '.counter.workouts':
            observe: 'workoutsCount'
            afterUpdate: highlight
          'button.btn-warning':
            observe: 'person_id'
            visible: (value) ->
              can('update', @model)

    events:
      'click button.btn-warning': '_onEdit'

    initialize: ->
      @data = new DataModel
      @listenTo @model, 'change:person_id', =>
        @data.set(person_id: @model.get('person_id'))
      @listenTo @model, 'change:weeks_count', =>
        return if @data.get('weeksCount') is @model.get('weeks_count')
        @data.set(weeksCount: @model.get('weeks_count'))
      @listenTo @model.workouts, 'reset add remove', =>
        @data.set(workoutsCount: @model.workouts.length)

    _onEdit: ->
      App.request 'modal:confirm',
        title: "Edit #{@model.get('name')}?"
        content:
          '''Changes will be saved immediately
          as soon as you move to the next field.'''
        confirmBtn: 'Update'
        confirmCallBack: =>
          path = ['personal_programs', @model.id, 'edit']
          App.vent.trigger('redirect:to', path, replace: false)
