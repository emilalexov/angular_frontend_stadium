define [
  './template'
  'models/video'
], (
  template
  Video
) ->

  class EditOverviewView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content gc-exercise-wrapper'

    behaviors:

      privacy_toggle2:
        instantSave: false

      delete_button:
        short: true

      video_assigned:
        instantSave: false

      textarea_autosize: true

      stickit:
        bindings:
          '.gc-exercise-name': 'name'
          'textarea': 'description'

    events:
      'click .gc-save-exercise': 'saveExercise'

    _attrs: ['name', 'description', 'video_id', 'video_url', 'is_public']

    initialize: ->
      @oldAttrs = @model.pick(@_attrs...)
      @listenTo(@, 'childview:video:assign', @videoAssign)
      @message = 'Are you sure you want to leave without saving?'
      @listenToOnce(@model, 'change', @unsavedChanges)

    unsavedChanges: ->
      @isChanged = true
      $(window).on('beforeunload', => @message)
      App.vent.trigger('unsaved:changes')
      $('a').on('click', @clickHandler)

    clickHandler: (ev) =>
      ev.preventDefault()
      path = ev.currentTarget.hash

      App.vent.trigger('redirect:to', path) if confirm(@message)

    saveExercise: ->
      @model.save()
        .then =>
          @removeListeners()
          @isChanged = false
          @trigger 'exercise:saved'

    removeListeners: ->
      $(window).off('beforeunload')
      App.vent.trigger('no:unsaved:changes')
      $('a').off('click', @clickHandler)

    onBeforeDestroy: ->
      @removeListeners()
      return unless @isChanged
      @model.set(@oldAttrs, silent: true)

    videoAssign: ->
      App.request('modal:video:assign', @model, instantSave: false)
