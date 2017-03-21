define ->

  class PromptModel extends Backbone.Model

    type: 'PromptModel'

    defaults:
      title: 'Title'
      description: ''
      confirmBtn: 'Confirm'
      label: 'Enter name'
      prompt: ''
      input_type: 'text'
      dismiss_on_submit: true

    validation:
      prompt:
        required: true
        msg: 'Required field'
