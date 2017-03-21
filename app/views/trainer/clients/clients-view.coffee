MoveToGroupView = require 'views/trainer/clients/move-to-group-view'

ClientFormModalView = require 'views/trainer/clients/client-form-modal-view'
Client = require 'models/client'

GroupFormModalView = require 'views/trainer/clients/group-form-modal-view'
ClientGroup = require 'models/client_group'

ClientGroupMember = require 'models/client_group_member'

module.exports = class ClientsView extends Marionette.LayoutView

  key: 'ClientsView'

  template: require('templates/trainer/clients/clients')

  className: 'clients-view-main-wrapper'

  events:
    'click .gc-content-nav-checkall': 'toggleCheck'
    'click .gc-clients-list-client-chb': 'updateState'
    'click .move-to-group-show': 'showMovetogroupModal'
    'click .show-client-form': 'showClientAddModal'
    'click .show-group-form': 'showGroupAddModal'
    'click @ui.removeButton': 'rmEvent'
    'submit .gc-move-to-group-form': 'submitMovetogroupForm'

  ui:
    mainCheckbox: ".gc-content-nav-checkall input[type='checkbox']"
    groupForm: '.group-form'
    checkedCounter: '.gc-clients-nav-right p'
    modalContainer: '#gc-modal-container'
    moveButton: '.move-to-group-show'
    removeButton: '.remove-item'
    clientsList: '.gc-clients-list-wrapper'
    clientsRegion: '#clients-region'
    groupsRegion: '#groups-region'
    splash: '#clients-groups-splash'

  regions:
    clients: '@ui.clientsRegion'
    groups: '#groups-region'
    modalContainer: '#gc-modal-container'

  behaviors: ->

    stickit:
      model: ->
        App.request('current_user').user_settings
      bindings:
        '.gc-nav-wrapper h2': 'clients_title'
        '.show-client-form .client-title':
          observe: 'clients_title'
          onGet: (value) ->
            "Add #{_.singularize(value)}"

  templateHelpers: =>
    view_type: @viewType

  initialize: (options) =>
    viewType = options.viewType || 'clients'
    @viewType = viewType

  initRegionListeners: =>
    if @clients.currentView? # temp fix for existing issue
      @listenTo @clients.currentView, 'individual:move', @showMovetogroupModal

  toggleCheck: (ev) =>
    checked = @ui.mainCheckbox.is(':checked')
    @ui.clientsList.find('input[type=checkbox]').prop('checked', checked)
    @updateButtonsState()
    @updateText()

  updateButtonsState: ->
    clientsCount = @countSelected(@clients.$el)
    groupsCount = @countSelected(@groups.$el)
    @ui.moveButton.toggle(clientsCount > 0)
    @ui.removeButton.toggle(clientsCount > 0 || groupsCount > 0)

  updateState: (ev) =>
    @updateButtonsState()
    @updateText()
    for check in @ui.clientsList.find('input[type=checkbox]')
      if needToggle?
        if needToggle != $(check).is(':checked')
          @ui.mainCheckbox.prop 'checked', false
          return
      needToggle = $(check).is(':checked')
    if needToggle
      @ui.mainCheckbox.prop 'checked', true

  updateText: =>
    text = @getSelectedListItemsAsText()
    if text
      @ui.checkedCounter.text(text + ' selected')
      @ui.checkedCounter.removeClass('hidden')
    else
      @ui.checkedCounter.addClass('hidden')

  getSelectedListItemsAsText: =>
    clientsCount = @countSelected(@clients.$el)
    groupsCount = @countSelected(@groups.$el)
    text = ''
    if clientsCount
      text += "#{clientsCount} client(s)"
    if clientsCount and groupsCount
      text += ', '
    if groupsCount
      text += "#{groupsCount} group(s)"
    text

  getNameForRemoveConfirmation: =>
    return @getSelectedListItemsAsText()

  removeItem: =>
    @clients.currentView?.trigger 'remove-client'
    @groups.currentView?.trigger 'remove-group'
    @updateState()

  showClientAddModal: (ev) ->
    clientModel = new Client
    clientFormModal = new ClientFormModalView model: clientModel

    @listenTo clientFormModal, 'closeModal', =>
      @ui.modalContainer.modal('hide')
    @listenTo clientFormModal, 'addToClientsCollection', (model) =>
      @ui.modalContainer.modal('hide')
    @listenTo clientFormModal, 'addToClientsCollection', (model)=>
      @clients.currentView.collection.add model
      @hideSplashIfVisible(@clients)

    @modalContainer.show clientFormModal
    @ui.modalContainer.modal('show')

  showGroupAddModal: (ev) ->
    groupModel = new ClientGroup
    groupFormModal = new GroupFormModalView model: groupModel

    @listenTo groupFormModal, 'closeModal', =>
      @ui.modalContainer.modal('hide')
    @listenTo groupFormModal, 'addToGroupsCollection', (model) =>
      @ui.modalContainer.modal('hide')
    @listenTo groupFormModal, 'addToGroupsCollection', (model)=>
      @hideSplashIfVisible(@groups)
      @groups.currentView.collection.unshift model

    @modalContainer.show groupFormModal
    @ui.modalContainer.modal('show')

  showMovetogroupModal: (ev) =>

    # add validation for empty groups
    if _.isEmpty(@groups.currentView.collection.models)
      App.request('messenger:explain', 'client_groups.empty')
    else
      moveToGroupView = new MoveToGroupView
        collection: @groups.currentView.collection
      @modalContainer.show moveToGroupView
      @ui.modalContainer.modal('show')

  submitMovetogroupForm: (ev) ->
    #TODO validation
    clientIds = []
    groupIds = []
    promises = []

    for check in @ui.clientsRegion.find('input[type=checkbox]:checked')
      clientIds.push $(check).data('id')
    els = @$el.find('.gc-move-to-group-form')
      .find('input[type=checkbox]:checked')
    for check in els
      groupIds.push $(check).data('id')

    groupIds.forEach (groupId) ->
      clientIds.forEach (clientId) ->
        clientGroupMember = new ClientGroupMember
          clientId: clientId
          groupId: groupId

        promises.push clientGroupMember.save()

    $.when.apply($, promises).done =>
      @ui.modalContainer.modal('hide')

  countSelected: ($el) ->
    return $el.find('input[type=checkbox]:checked').length

  rmEvent: (ev) =>
    App.request 'modal:confirm',
      title: 'Delete items'
      content: 'Are you sure you want to delete selected items?'
      confirmBtn: 'Delete'
      confirmCallBack: =>
        App.vent.trigger 'rm-client'
        App.vent.trigger 'rm-group'
        clientLength = @clients.currentView?.collection.length
        groupLength = @groups.currentView?.collection.length
        if @clients.currentView? and @groups.currentView?
          if clientLength == 0 and groupLength == 0
            @showSplash([@clients, @groups])
        else if @clients.currentView?
          if clientLength == 0
            @showSplash([@clients])
        else if @groups.currentView?
          if groupLength == 0
            @showSplash([@groups])
        @updateButtonsState()

  # view can either be clients or groups view (which ever is active)
  hideSplashIfVisible: (view) ->
    if view.$el.hasClass 'hidden'
      view.$el.removeClass 'hidden'
      @ui.splash.addClass 'hidden'

  showSplash: (views) =>
    views.forEach (view) ->
      view.$el.addClass 'hidden'

    @ui.splash.removeClass 'hidden'
