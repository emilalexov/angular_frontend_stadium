define [
  './template'
  './list/view'
  'features/payment/trial_ends_soon/view'
], (
  template
  StatsListView
  TrialEndsSoonView
) ->

  class StatsLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-main-workspace'

    behaviors:

      regioned:
        views: [
            region: 'stats_list'
            klass: StatsListView
            options: ->
              collection: @collection
          ,
            region: 'trial_ends_soon'
            klass: TrialEndsSoonView
            enabled: ->
              date = @model.get('subscription_end_at')
              daysLeft = moment(date).diff(moment(), 'days')
              !@model.get('is_pro') && @model.get('is_trialing') && daysLeft < 5
        ]

      stickit:
        bindings:
          'h2 span':
            observe: 'user_profile.first_name'
            onGet: (value) ->
              if _.any(value)
                "Welcome, #{value}!"
              else
                'Welcome back!'

    constructor: ->
      @model = App.request('current_user')
      super
