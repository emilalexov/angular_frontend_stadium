define [
  './template'
], (
  itemViewTpl
) ->

  class PersonalEntityItemView extends Marionette.ItemView

    template: itemViewTpl

    tagName: 'li'

    className: 'row gc-folder'

    behaviors: ->

      mobile_only_features: true

      enter_results_for_new_workout_event:
        id: => @model.id

      stickit:
        bindings:
          '.name': 'name'
          '.gc-exercises-link':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: ->
                  root = _.chain(@model.type).underscore().pluralize().value()
                  if root is 'exercises'
                    userId = App.request('current_user_id')
                    "#users/#{userId}/#{root}/#{@model.get('exercise_id')}"
                  else
                    "##{root}/#{@model.id}"
            ]
          '.gc-client-item-icon':
            attributes: [
                name: 'class'
                observe: 'id'
                onGet: ->
                  type = _.chain(@model.type).underscore().pluralize().value()
                  "gc-client-item-icon-#{type}"
            ]
          'span.workout':
            observe: 'workout_name'
            visible: (value) -> !!value
          '.gc-workout-link':
            observe: 'workout_name'
            attributes: [
                name: 'href'
                observe: 'workout_id'
                onGet: (value) ->
                  "#personal_workouts/#{value}"
            ]
          '.schedule-buttons':
            observe: 'id'
            visible: (value) ->
              @model.type is 'PersonalWorkout'
