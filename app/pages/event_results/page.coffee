define [
  'pages/base/page'
  './template'
  'features/event_results/view'
  'models/workout_event'
  'features/user_profile_stats_widget/view'
  'moment'
], (
  BasePage
  template
  EventExerciseResultCollectionView
  WorkoutsEvent
  UserProfileStatsWidget
  moment
) ->

  class EventResultsPage extends BasePage

    className: 'gc-event-results gc-main-workspace'

    behaviors: ->

      navigate_back: true

      stickit:
        model: -> @model.get('data.model')
        bindings:
          '.name': 'workout_name'
          '.date':
            observe: 'begins_at'
            onGet: (dateTime) ->
              return '' unless dateTime
              moment(dateTime).format('MM/DD/YYYY h:mm A')
          '.prev': classes:
            disabled:
              observe: 'prev_id'
              onGet: (id) -> !id
          '.next': classes:
            disabled:
              observe: 'next_id'
              onGet: (id) -> !id
          '.prev a': attributes: [
              name: 'href'
              observe: 'prev_id'
              onGet: @_siblingEventUrl
          ]
          '.next a': attributes: [
              name: 'href'
              observe: 'next_id'
              onGet: @_siblingEventUrl
          ]

      regioned:
        views: [
            region: 'user_profile_stats_widget'
            klass: UserProfileStatsWidget
            options: ->
              event: @model.get('data.model')
        ]

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initModel: ->
      new WorkoutsEvent
        id: @options.id

    initViews: ->
      root: ->
        new EventExerciseResultCollectionView
          model: @model.get('data.model')

    _siblingEventUrl:  (id) ->
      return '#' unless id
      "/#events/#{id}/results"
