define [
  'features/presets_load/user_account_type/view'
  './template'
], (
  AccountTypeModalView
  template
) ->

  class ChangeAccountTypeModalView extends AccountTypeModalView

    template: template

    events:
      'click .cancel': '_onCancel'
      'click a.change-account-type': '_onChange'

    initialize: ->
      @settings = App.request('current_user').user_settings
      @accountTypeId = @settings.get('user_account_type_id')

    _onCancel: ->
      @settings.set(user_account_type_id: @accountTypeId)

    _onChange: ->
      isAccountTypeSelected = @views.user_account_types.saveAccountType()
      isAccountTypeSelected?.then =>
        @accountTypeId = @settings.get('user_account_type_id')
        @trigger('modal:closed')
