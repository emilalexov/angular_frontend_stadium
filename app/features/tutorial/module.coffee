define [
  'features/tutorial/collection'
  'features/tutorial/template'
  'features/tutorial/tooltips'
  'bootstrap-tour'
], (
  TutorialStepsCollection
  template
  tooltips
) ->

  class Module extends Marionette.Module

    initialize: ->
      @tour = @_initTour()
      App.reqres.setHandler('tour', => @tour)
      App.vent.on('app:view:show', @onShowView, @)
      App.vent.on('app:view:destroy', @onBeforeDestroyView, @)
      $(document).one 'click', "button[data-role='finish_tour']", =>
        steps = _.pluck(tooltips, 'uniq_id')
        @tour.collection.skipSteps(steps)
        @tour.end() unless @tour.ended()

    _getTourClass: ->
      window.Tour::addStep = (step) ->
        @collection.add(step) if step
        @

      window.Tour::getStep = (i) ->
        step = @collection.getStep(i)
        return unless step
        $.extend({
          id: 'step-' + i
          path: ''
          host: ''
          placement: 'auto'
          title: ''
          content: '<p></p>'
          next: if i == @_options.steps.length - 1 then -1 else i + 1
          prev: i - 1
          animation: true
          container: @_options.container
          autoscroll: @_options.autoscroll
          backdrop: @_options.backdrop
          backdropContainer: @_options.backdropContainer
          backdropPadding: @_options.backdropPadding
          redirect: @_options.redirect
          reflexElement: step.element
          orphan: @_options.orphan
          duration: @_options.duration
          delay: @_options.delay
          template: @_options.template
          onShow: @_options.onShow
          onShown: @_options.onShown
          onHide: @_options.onHide
          onHidden: @_options.onHidden
          onNext: @_options.onNext
          onPrev: @_options.onPrev
          onPause: @_options.onPause
          onResume: @_options.onResume
          onRedirectError: @_options.onRedirectError
        }, step)

      window.Tour::restartTour = ->
        @collection.restartTour()

      TourClass = window.Tour
      delete window.Tour
      TourClass

    _getTourInstance: ->
      TourClass = @_getTourClass()
      new TourClass
        storage: false
        name: 'tour'
        steps: []
        smartPlacement: true
        backdrop: true
        backdropContainer: 'body'
        backdropPadding: 0
        onShown: (tour) -> tour.collection.saveShowedStep(tour.getCurrentStep())
        template: (i, step) ->
          tour = App.request('tour')
          params = _.extend {}, step,
            currentIndex: i + 1
            totalCount: tour.collection.length - 1
          template(params)

    _lastStep: ->
      id: 99
      uniq_id: 'last_step'
      element: 'body'
      title: ''
      content: ''
      docs: ''
      onShown: (tour) -> !tour.ended() and tour.end()

    _initTour: ->
      tour = @_getTourInstance()
      tour.collection = new TutorialStepsCollection
      tour.addStep(@_lastStep())
      @listenTo(tour.collection, 'reset', => tour.addStep(@_lastStep()))

      delete tour._options.steps
      tour._options.__defineGetter__('steps', -> tour.collection.toJSON())

      tour.init()
      tour

    onShowView: (view) ->
      steps = _.reduce tooltips, (memo, step) ->
        if step.key is view.key and _.bind(step.rule, view, view)()
          newStep = _.clone(step)
          newStep.element = step.element(view)
          newStep.view = view
          memo.push(newStep)
        memo
      , []

      return unless steps.length
      @tour.addSteps(steps)

      return unless _.where(steps, main: true).length
      @tour.restart() if @tour.collection.length > 1

    onBeforeDestroyView: (view) ->
      steps = @tour.collection.where(view: view)
      @tour.collection.remove(steps)

      return unless steps.length

      if !@tour.ended() and @tour.collection.length
        try
          @tour.end()
          @tour.collection.reset()
        catch err
