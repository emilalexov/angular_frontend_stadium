module.exports = class MoveToGroupView extends Marionette.ItemView

  template: require('templates/trainer/clients/move_to_group')

  className: 'modal-dialog modal-sm'

  events:
    'submit .gc-move-to-group-form': 'submitMovetogroupForm'
