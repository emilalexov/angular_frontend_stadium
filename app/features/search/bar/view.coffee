define [
  './template'
], (
  template
) ->

  class SearchBarView extends Marionette.ItemView

    template: template

    className: 'gc-topbar-search'

    events:
      'blur @ui.searchTerm': 'searchFocusLost'
      'click @ui.searchButton': 'search'
      'keyup @ui.searchTerm' : 'searchOnEnter'
      'focus @ui.searchTerm': 'activateSearch'

    ui:
      searchTerm: '#gc-topnav-search'
      searchIcon: '.gc-topnav-search-icon'
      searchButton: '.gc-topnav-search-btn'

    searchOnEnter: (ev)->
      if ev.which is 13
        @doSearch @ui.searchTerm.val()
      else if ev.which is 27
        @cancelSearch()

    doSearch: (q)->
      if q isnt ''
        App.vent.trigger 'search:global', q

    activateSearch: ->
      @ui.searchIcon.removeClass('glyphicon-search')
      @ui.searchIcon.addClass('glyphicon-remove')

    cancelSearch: ->
      @ui.searchTerm.val('')
      unless @ui.searchTerm.is(':focus')
        @ui.searchIcon.addClass('glyphicon-search')
        @ui.searchIcon.removeClass('glyphicon-remove')
      App.vent.trigger 'search:cancel'

    search: (ev) ->
      isSearchInProgress = @ui.searchButton.find('i')
        .hasClass('glyphicon-remove')
      if isSearchInProgress
        do @cancelSearch
      else
        @doSearch(@ui.searchTerm.val())

    searchFocusLost: (ev) ->
      ev.preventDefault()
      $sr = $(ev.currentTarget)
      if $sr.val() isnt $sr.attr('placeholder') and $sr.val() isnt ''
        $sr.addClass('active')
      else
        $sr.removeClass('active')
        @cancelSearch()
