module.exports = class ClientGroupNavView extends Marionette.ItemView

  template: require('templates/trainer/clients/client-group-nav')

  events:
    'click @ui.deleteButton': 'deleteButtonClick'

  ui:
    nav: '.gc-content-nav a'
    navLink: '.gc-content-nav :not(.gc-content-nav-back) a'
    deleteButton: '.gc-content-nav-delete'

  templateHelpers: =>
    client_id: @itemId
    view_name: @viewName

  initialize: (data) ->
    @itemId = data.itemId
    if data.viewType is 'clients'
      @viewName = 'clients'
    else
      @viewName = 'groups'
    @on 'changeActive', @changeActive

  navigate: (navView) ->
    @ui.nav.parent().removeClass('active')
    @ui.nav.each (index, element) ->
      if $(element).data('nav-view') == navView
        $nav = $(element)
        $nav.parent().addClass('active')
    @trigger 'navView', navView

  deleteButtonClick: (ev) ->
    App.vent.trigger 'content-nav:delete'

  changeActive: (category) =>
    @ui.nav.parent().removeClass('active')
    @$el.find(".gc-content-nav a[data-nav-view = #{category}]")
      .parent().addClass('active')
