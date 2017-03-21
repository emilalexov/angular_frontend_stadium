define ->

  tour = null
  getFinishedSteps = ->
    return unless App.reqres.hasHandler('current_user_id')
    settings = App.request('current_user').user_settings
    tour = settings.get('tutorial_steps')

  class TutorialStepsCollection extends Backbone.Collection

    comparator: (step) ->
      step.get('id')

    add: (models, options) ->
      getFinishedSteps() unless tour
      steps = if _.isArray(models) then models else [models]
      models = _.filter(steps, (s) -> s and !_.include(tour, s?.uniq_id))
      super

    getStep: (i) ->
      step = @at(i)
      step?.toJSON()

    saveShowedStep: (i) ->
      step = @at(i)
      return null unless step
      uid = step.get('uniq_id')
      @skipSteps([uid]) unless _.include(tour, uid)

    skipSteps: (steps = []) ->
      tour = _.uniq(tour.concat(steps))
      user = App.request('current_user')
      settings = user.user_settings
      settings.patch(tutorial_steps: tour)

    restartTour: ->
      tour = []
      user = App.request('current_user')
      settings = user.user_settings
      settings.patch
        tutorial_steps: tour
        is_tutorial_finished: false
