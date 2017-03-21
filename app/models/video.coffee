define ->

  class VideoModel extends Backbone.Model

    urlRoot: '/videos'

    type: 'Video'

    defaults:
      preview: undefined
      duration: undefined
      filter: undefined
      title: undefined
      isAssigned: undefined

    initialize: ->
      @computedFields = new Backbone.ComputedFields(@)

    computed: ->
      nameFormatted:
        depends: ['name']
        get: (attrs) =>
          @_stripExtention(attrs.name)
      durationFormatted:
        depends: ['duration']
        get: (attrs) =>
          @_convertDuration(attrs.duration)

    _stripExtention: (name) ->
      re = /\.(webm|mkv|flv|vob|mp4|m4v|avi|mpeg|mpg|3gp|mov)$/i
      name?.replace(re, '')

    _convertDuration: (duration) ->
      return null unless duration
      format = if duration > 60 * 60 then 'HH:mm:ss' else 'mm:ss'
      moment.utc(duration * 1000).format(format)
