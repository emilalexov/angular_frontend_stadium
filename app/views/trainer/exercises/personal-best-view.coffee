PersonalBestModalView = require './personal-best-modal'

class PersonalBestModel extends Backbone.Model

class PersonalBestCollection extends Backbone.Collection

  urlRoot: '/api/mobile'

  model: PersonalBestModel

class EmptyView extends Marionette.ItemView

  template: require('templates/trainer/exercises/personal-best-empty')

class PersonalBestItemView extends Marionette.ItemView

  template: require('templates/trainer/exercises/personal-best-item')

  tagName: 'li'

  className: 'gc-exercises-bests-best'

  model: PersonalBestModel

  ui:
    deleteButton: '.gc-exercises-bests-delete'

  events:
    'click @ui.deleteButton': 'deletePersonalBest'

  modelEvents:
    sync: 'render'

  deletePersonalBest: (ev) =>
    App.request('modal:confirm:delete', @model)

class PersonalBestCollectionView extends Marionette.CollectionView

  childView: PersonalBestItemView

  childViewContainer: 'ul'

  emptyView: EmptyView

module.exports = class PersonalBestView extends Marionette.LayoutView

  template: require('templates/trainer/exercises/personal-best')

  ui:
    showModal: '.gc-add-personal-best'
    modal: '#gc-add-personal-best-modal'

  events:
    'click @ui.showModal': 'showAddPersonalBestModal'

  regions:
    list: '#gc-personal-best-collection'
    modal: '#gc-add-personal-best-modal'

  initialize: (data) =>
    @itemId = data.itemId
    @assign = data.assign
    @key = data.key
    if parseInt(@itemId) is 0
      @myProfile = true

  onShow: =>
    @personalBest = new PersonalBestCollection
    if @myProfile
      @personalBest.url =
        "#{@personalBest.urlRoot}/me/#{@assign}/#{@key}/records"
    else
      @personalBest.url =
        "#{@personalBest.urlRoot}/clients/#{@itemId}/#{@assign}/#{@key}/records"
    @personalBest.fetch()
    personalBestView = new PersonalBestCollectionView collection: @personalBest
    @list.show personalBestView

  showAddPersonalBestModal: =>
    modal = new PersonalBestModalView
      id: @itemId
      item_id: @key
    @modal.show modal
    @ui.modal.modal 'show'
    @listenTo modal, 'personal_best:added', @personalBestAdded

  personalBestAdded: =>
    @ui.modal.modal 'hide'
    App.request('messenger:explain', 'personal_best.added')
    @personalBest.fetch()
