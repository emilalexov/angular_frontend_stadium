define ->

  class RedirectBackOnDestroyBehavior extends Marionette.Behavior

    key: 'redirect_back_on_destroy'

    onShow: ->
      model = _.bind(@options.model, @)()
      @listenTo model, 'destroy', (model) ->
        type = _.chain(model.type)
          .pluralize()
          .underscored()
          .value()
        id = model.parent.get('id')
        path = "#/#{type}_folder/#{id}"
        App.vent.trigger('redirect:to', path)
