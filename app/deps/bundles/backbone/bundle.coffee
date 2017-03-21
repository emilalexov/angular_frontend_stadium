define [
  'deps/bundles/jquery/bundle'
  'backbone_original'
  'backbone.stickit'
  'backbone-virtual-collection'
  'backbone-nested'
  'backbone-computedfields'
  'imports?Backbone=deps/bundles/backbone/original' +
    '&_=deps/bundles/underscore/original!backbone-validation'
], (
  b$
  oBackbone
)->

  oBackbone
  oBackbone.$ = b$

  _.extend oBackbone.Model::,
    patch: (attrs = {}) ->
      if _.isEmpty(attrs)
        attrs = @changedAttributes()
        return false if _.isEmpty(attrs)
      @save(attrs, patch: true, wait: true)

  oBackbone.Stickit.addHandler
    selector: '[contenteditable]'
    updateMethod: 'html'
    getVal: ($el) ->
      $el.text()
    events: ['change', 'input']

  oBackbone
