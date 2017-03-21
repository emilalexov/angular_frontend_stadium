define [
  './template'
  './item/view'
  './model'
  'models/exercise_property'
  'collections/exercise_properties'
  'collections/properties'
], (
  template
  ItemView
  Model
  ExerciseProperty
  ExerciseProperties
  Properties
) ->

  class ExercisePropertiesMultiConstructor extends Marionette.CompositeView

    template: template

    childView: ItemView

    childViewContainer: 'ul.gc-workout-exercise-property-list'

    behaviors:
      stickit:
        bindings:
          '.gc-constructor-empty-state':
            observe: 'state'
            visible: (value) ->
              value is 'empty'
          '.gc-assign-property':
            observe: 'state'
            visible: (value) ->
              value isnt 'empty'

    ui:
      addButton: 'a.gc-add-property-button'
      assignButton: '.gc-assign-property'

    events:
      'click @ui.addButton': 'addProperty'
      'click @ui.assignButton': 'assignProperties'

    constructor: ->
      @collection = new ExerciseProperties
      @model = new Model
      super

    initialize: (options) ->
      @listenTo @collection, 'reset add remove', =>
        state = @collection.isEmpty() && 'empty' || 'collection'
        @model.set('state', state)
      @listenTo @model, 'change:state', (_model, value) =>
        if value is 'collection'
          @trigger('multi_constructor:start')
        else if value is 'empty'
          @trigger('multi_constructor:stop')

      @listenTo(@, 'actions:show', -> @$el.removeClass('hidden'))
      @listenTo(@, 'actions:hide', -> @$el.addClass('hidden'))

    addProperty: ->
      @collection.add({})

    assignProperties: ->
      models = @collection.filter (model) -> !!model.get('personal_property_id')
      @trigger('multi_constructor:assign', models)
      @collection.reset()
