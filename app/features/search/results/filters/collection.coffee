define ->

  class Model extends Backbone.Model

    defaults:
      id: undefined
      name: undefined
      href: undefined
      isSelected: undefined

  class Collection extends Backbone.Collection

    model: Model
