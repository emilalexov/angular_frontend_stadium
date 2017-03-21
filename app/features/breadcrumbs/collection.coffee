define ->

  class Collection extends Backbone.Collection

    initFromModel: (model) ->
      @reset()
      @buildFromModel(model)

    buildFromModel: (model) ->
      @unshift(model)
      parent = model.parent
      if parent? and not _.isNull(parent.get('parent_id'))
        @buildFromModel(parent)
