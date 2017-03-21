define ->

  class Helpers

    constructor: (@moment) -> @

    ago: (value) ->
      @moment(value).fromNow()

    full: (value) ->
      @moment(value).format('LLL')

    onlyDate: (value) ->
      @moment(value).format('MMM DD')

    onlyTime: (value) ->
      @moment(value).format('HH:mm A')
