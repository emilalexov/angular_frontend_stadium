define [
  'backbone-nested'
], ->

  class PageModel extends Backbone.Model

    defaults:
      'state.subpage': 'default'
      'data.model': undefined
      'data.collection': undefined
