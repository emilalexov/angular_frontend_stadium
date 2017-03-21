define ->

  class Model extends Backbone.Model

    defaults:
      id: undefined
      name: undefined
      values: undefined
      inScope: undefined

  class Collection extends Backbone.Collection

    model: Model
