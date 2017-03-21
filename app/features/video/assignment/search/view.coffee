define [
  './template'
], (
  template
) ->

  class SearchInputView extends Marionette.ItemView

    template: template

    ui:
      button: '.video-search-btn'
      input: 'input'

    events:
      'keydown @ui.input': '_getSearchQuery'
      'click @ui.button:not(.disabled)': '_getSearchQuery'

    modelEvents:
      'change query': '_highlightSearchBtn'

    behaviors:
      form_validation: true

      stickit:
        bindings:
          'input': 'query'

    _getSearchQuery: (event) ->
      if (event.which isnt 13 and
      not $(event.target).hasClass('video-search-btn'))
        return event
      @trigger('searchStart', @model.get('query'))

    _highlightSearchBtn: ->
      isEmpty = !!@model.get('query').length
      @ui.button.toggleClass('disabled', !isEmpty)
