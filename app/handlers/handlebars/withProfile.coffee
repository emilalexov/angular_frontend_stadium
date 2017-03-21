Handlebars = require('handlebars')

module.exports = (options) ->
  profileModel = App.request('current_user')
  context = profileModel.attributes
  Handlebars.helpers.with.call(@, context, options)
