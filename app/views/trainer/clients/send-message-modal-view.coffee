Clients = require 'collections/clients'
Message = require 'models/message'

module.exports = class SendMessageModalView extends Marionette.ItemView

  template: require('templates/trainer/clients/send-message-modal')

  className: 'modal-dialog'

  initialize: (data) ->
    @model = new Message
    Backbone.Validation.bind @
    @selectedItems = data.selectedItems

  onShow: ->
    @initSearchSelect()

  ui:
    liveSearch:   '.live-search'
    form:         'form'
    messageBody:  'textarea[name=body]'
    messageNone:  '.gc-send-msessage-none'
    messageAll:   '.gc-send-msessage-none'

  events:
    'click  @ui.messageNone': 'selectNone'
    'click  @ui.messageAll':  'selectAll'
    'submit @ui.form':        'submitForm'

  searchItems: (models) ->
    listItems = []
    for model in models
      item = new Object
      item.id = model.get 'id'
      item.last_name = model.get 'last_name'
      item.first_name = model.get 'first_name'
      item.color = model.get 'avatar_background_color'
      item.url = model.get 'avatar_url'
      listItems.push item
    listItems

  initSearchSelect: =>
    clientCollection = new Clients
    clientCollection.fetch().then =>
      options = @searchItems clientCollection.models
      this_ = @
      @ui.liveSearch.selectize
        plugins: ['remove_button']
        hideSelected: true
        valueField: 'id'
        labelField: 'first_name'
        searchField: ['first_name', 'last_name']
        options: options
        render:
          item: (item, escape) ->
            '<div>' + escape(item.first_name) +
              ' ' + escape(item.last_name) + '</div>'
          option: (item, escape) ->
            return "<div><span class='avatar' style='background-color: " +  \
              item.color + ";'><img src='" + item.url + "'></span>" + \
              escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'
      for item in @selectedItems
        @ui.liveSearch[0].selectize.addItem item

  selectNone: (ev) =>
    @ui.liveSearch[0].selectize.clear()

  selectAll: (ev) =>
    @ui.liveSearch[0].selectize
      .setValue(Object.keys(@ui.liveSearch[0].selectize.options))

  submitForm: (ev) ->
    isError = false
    clients = @ui.liveSearch.val()
    message = @ui.messageBody.val()
    @model.set 'clients', clients
    @model.set 'body', message
    if @model.isValid true
      data =
        body: message
      for clientId in clients.split(',')
        $.ajax
          url: "/api/mobile/conversations/users/#{clientId}/messages"
          type: 'POST'
          dataType: 'json'
          data: JSON.stringify data
        @trigger 'modal:close'
