moment = require('moment')

module.exports = (date, options) ->
  if date
    moment().diff(date, 'years')
