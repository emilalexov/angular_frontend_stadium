define [
  './template'
], (
  template
) ->
  class AccountTypeItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'account-type-item'

    events:
      'click': 'changeSelected'

    behaviors:

      stickit:
        bindings:
          ':el':
            classes:
              active: 'is_selected'
          'h5': 'name'
          '.account-selected':
            classes:
              assigned: 'is_selected'

    initialize: ->
      user = App.request('current_user')
      @settings = user.user_settings

      @model.set
        is_selected: @model.id is @settings.get('user_account_type_id')

      @listenTo @settings, 'change:user_account_type_id', (model, value, _) =>
        @model.set(is_selected: @model.id is value)

    changeSelected: ->
      currentId = @settings.get('user_account_type_id')
      return false if currentId is @model.id
      @settings.set(user_account_type_id: @model.id)
