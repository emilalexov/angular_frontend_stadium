define [
  './template'
  '../model'
  'features/quick_add/view'
], (
  template
  DataModel
  QuickAddView
) ->

  class EditableProgramActionPanel extends Marionette.LayoutView

    key: 'EditableProgramActionPanel'

    template: template

    className: 'program-action-panel'

    behaviors: ->
      author_widget:
        enabled: ->
          @view.options.model.type is 'ProgramTemplate'
      privacy_button:
        enabled: ->
          @view.options.model.type is 'ProgramTemplate'

      stickit:
        model: -> @data
        bindings: ->
          highlight = ($el) ->
            $el.addClass('highlight')
            setTimeout (-> $el.removeClass('highlight')), 350

          '.counter.weeks':
            observe: 'weeksCount'
            events: ['change', 'blur']
            afterUpdate: highlight
            onSet: (value) ->
              0 + (value + '').replace(/\D/g, '') or 0
          '.counter.workouts':
            observe: 'workoutsCount'
            afterUpdate: highlight
          '.counters':
            observe: 'state'
            visible: (value) ->
              value isnt 'autocomplete'
          '.back-to-overview':
            observe: 'person_id'
            visible: (value) ->
              @model.type is 'PersonalProgram'
          '.widgets':
            observe: 'position'
            visible: (value) ->
              value is 'top'

      regioned:
        views: [
            region: 'quick_add'
            klass: QuickAddView
            options: ->
              collection: App.request('current_user').workout_templates
              typeToAdd: 'Workout'
              newButtonName: 'Add New'
        ]

    ui:
      counters: '.counters'
      addWeekBtn: 'button.add-week'
      addWorkoutBtn: 'button.add-workout'

    events:
      'click @ui.addWeekBtn': '_addWeek'
      'click @ui.addWorkoutBtn': '_showAutocomplete'
      'click .back-to-overview': '_backToOverview'
      'keypress .counter.weeks': '_onWeeksCountChange'

    initialize: ->
      @data = new DataModel
        position: @options.position || 'top'
        weeksCount: @model.get('weeks_count')
      @listenTo @model, 'change:person_id', =>
        @data.set(person_id: @model.get('person_id'))
      @listenTo @model, 'change:weeks_count', =>
        return if @data.get('weeksCount') is @model.get('weeks_count')
        @data.set(weeksCount: @model.get('weeks_count'))
      @listenTo @model.workouts, 'reset add remove', =>
        @data.set(workoutsCount: @model.workouts.length)
      @listenTo @model.weeks, 'add', =>
        @model.save({weeks_count: @model.get('weeks_count') + 1}, wait: true)
      @listenTo @model.weeks, 'remove', =>
        count = @model.get('weeks_count') - 1
        count = 0 if count < 0
        @model.save({weeks_count: count}, wait: true)
      @listenTo @data, 'change:weeksCount', =>
        @model.save({weeks_count: @data.get('weeksCount')}, wait: true)

    onShow: ->
      @listenTo @views.quick_add, 'quick_add:chosen', (id) =>
        @_addWorkoutToCollection(parseInt(id) || undefined)
      @listenTo @views.quick_add.model, 'change:state', (_model, state) =>
        @data.set('state', state)

    _showAutocomplete: ->
      @views.quick_add.trigger('autocomplete')

    _addWorkoutToCollection: (id) ->
      position = @_calculatePosition(@model.workouts)
      @model.workouts.create
        program_id: @model.get('id')
        program_type: @model.type
        workout_template_id: id
        position: position
      ,
        wait: true

    _addWeek: ->
      position = @_calculatePosition(@model.weeks)
      @model.weeks.create
        program_id: @model.get('id')
        program_type: @model.type
        position: position
        name: 'Week'
      ,
        wait: true

    _calculatePosition: (collection) ->
      if @data.get('position') is 'bottom'
        lastModelPosition = collection.last()?.get('position') or null
        lastModelPosition + 1
      else
        firstModelPosition = collection.first()?.get('position') or null
        firstModelPosition - 1

    _backToOverview: ->
      path = ['personal_programs', @model.id]
      App.vent.trigger('redirect:to', path, replace: false)

    _onWeeksCountChange: (ev) ->
      return false if ev.currentTarget.innerText.length >= 3
      char = String.fromCharCode(ev.keyCode || ev.which)
      return false unless char.match(/[\d]/)
