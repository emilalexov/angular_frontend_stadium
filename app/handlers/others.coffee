define [
  'features/add_to_library/view'
  'views/trainer/workouts/workout_schedule_modal_view'
  'models/workout_schedule'
  'features/presets_load/view'
  'features/video/upload/view'
  'features/video/upload/model'
], (
  ModalAddToLibraryView
  WorkoutScheduleView
  WorkoutSchedule
  PresetsLoadModalView
  VideoUploadModalView
  VideoModel
) ->

  (App) ->

    App.listenTo App.vent, 'redirect:to', (path, options = {}) ->
      opts = _.defaults options,
        replace: true
        trigger: true
      if _.isArray(path)
        path = path
          .join('/')
          .replace(/^([^\#])/, '#$1')
      Backbone.history.navigate(path, opts)

    App.reqres.setHandler 'fwd', (options = {}) ->
      _.each options.events, (fromEvent) ->
        options.context.listenTo options.from, fromEvent, ->
          args = _.toArray(arguments)
          to = _.result(options, 'to')
          toEvent = fromEvent
          if options.prefix
            toEvent = [
              options.prefix
              toEvent
            ].join(':')
          if options.suffix
            toEvent = [
              toEvent
              options.suffix
            ].join(':')
          if options.each is true
            to.each (eachTo) ->
              eachTo.trigger(toEvent, args...)
          else
            to.trigger(toEvent, args...)

    App.reqres.setHandler 'base:addToLibraryModal', (data) ->
      addToLibraryView = new ModalAddToLibraryView data
      region = App.baseView.getRegion('modal')
      region.show(addToLibraryView)
      region.$el.modal('show')
      region.$el.one 'hidden.bs.modal', ->
        addToLibraryView.destroy()

    App.reqres.setHandler 'base:workoutSchedule', (data) ->
      view = new WorkoutScheduleView
        model: new WorkoutSchedule

      region = App.baseView.getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      App.listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()

    App.reqres.setHandler 'base:accountTypes', (data) ->
      view = new PresetsLoadModalView

      region = App.baseView.getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      App.listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()

    App.reqres.setHandler 'base:uploadVideo', ->
      model = new VideoModel
      view = new VideoUploadModalView
        model: model

      region = App.baseView.getRegion('modal')
      region.show(view)
      region.$el.modal
        keyboard: false
        background: 'static'

      region.$el.modal 'show'

      App.listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()

      view

    App.reqres.setHandler 'ajax:options:create', (params) ->
      options =
        url: params.url
        type: params.type || 'POST'
        contentType: params.contentType || 'application/json'
        data: params.data || '{}'

    App.reqres.setHandler 'check:trial', ->
      user = App.request('current_user')
      endDate = user.get('subscription_end_at')
      trialing = user.get('is_trialing')
      if trialing and moment(endDate) < moment()
        App.vent.trigger('redirect:to', '#trial_ended')
        return true
      return false
