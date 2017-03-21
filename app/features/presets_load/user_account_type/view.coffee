define [
  './template'
  './list/view'
], (
  template
  UserAccountTypeListView
) ->

  class AccountTypeModalView extends Marionette.LayoutView

    template: template

    behaviors:

      regioned:
        views: [
            region: 'user_account_types'
            klass: UserAccountTypeListView
        ]

    events:
      'click a.change-account-type': '_goNext'

    _goNext: ->
      isAccountTypeSelected = @views.user_account_types.saveAccountType()
      @trigger('changeView', 'next') if isAccountTypeSelected
