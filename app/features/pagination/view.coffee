define [
  './template'
], (
  template
) ->
  class PaginationView extends Marionette.ItemView

    template: template

    className: 'paginator'

    ui:
      prevPage: '.pagination li:first a'
      nextPage: '.pagination li:last a'
      searchPage: '.pagination li:not(:first, :last) a'

    events:
      'click @ui.prevPage': 'getPrevPage'
      'click @ui.nextPage': 'getNextPage'
      'click @ui.searchPage': 'getSearchPage'

    templateHelpers: ->
      currentPageInfo: @_currentPageInfo()
      totalPages: @collection.state.totalPages or 1

    initialize: ->
      @listenTo(@collection, 'reset', @_renderPageNumbers)

    getPrevPage: (ev) ->
      ev.preventDefault()
      @collection.getPreviousPage()

    getNextPage: (ev) ->
      ev.preventDefault()
      @collection.getNextPage()

    getSearchPage: (ev) ->
      ev.preventDefault()
      page = parseInt $(ev.currentTarget).text()
      @collection.getPage(page)

    _renderPageNumbers: ->
      return @$el.hide() if @collection.state.totalPages < 2

      @$el.show()
      @render()

    _currentPageInfo: ->
      state = @collection.state
      first = (state.currentPage - 1) * state.pageSize + 1
      last = state.currentPage * state.pageSize
      last = state.totalRecords if last > state.totalRecords
      "Showing #{first} to #{last} of #{state.totalRecords} videos"
