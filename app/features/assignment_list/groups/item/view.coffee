define [
  'models/personal_workout'
  './template'
], (
  PersonalWorkout
  template
) ->

  class GroupItemView extends Marionette.ItemView

    tagName: 'li'

    template: template

    className: 'row gc-workout-client-item'

    events:
      'click': 'toggleAssign'

    behaviors:

      stickit:
        bindings:
          '.gc-clients-list-avatar-wrapper':
            attributes: [
                observe: 'avatar_background_color'
                name: 'style'
                onGet: (val) ->
                  (val && "background-color: #{val}") || ''
            ]
          '.glyphicon-ok':
            attributes: [
                observe: ['assigned_count', 'is_assigned']
                name: 'class'
                onGet: ([assigned_count, is_assigned]) ->
                  cssClass = ''
                  unless is_assigned
                    cssClass = if assigned_count then 'partial' else 'hidden'
                  "glyphicon glyphicon-ok #{cssClass}"
            ]

    initialize: (options) ->
      @entity = options.entity

    toggleAssign: (ev) =>
      if @model.get('is_assigned')
        type = @entity.type
        App.request 'modal:confirm',
          title: "Unassign #{type}?"
          content: "Are you sure you want unassign #{type} from group?"
          confirmBtn: 'Unassign'
          confirmCallBack: =>
            @model.unassign(@entity).then (response) =>
              @model.set(response)
              @_toggleAssignSuccess('unassign')
      else
        @model.assign(@entity).then (response) =>
          @model.set(response)
          @_toggleAssignSuccess('assign')

    _toggleAssignSuccess: (actionType) ->
      type = @entity.type
      if actionType is 'assign'
        App.request 'messenger:explain', 'item.client_group.assigned',
          type: type
      else
        App.request 'messenger:explain', 'item.client_group.unassigned',
          type: type
      @render()
