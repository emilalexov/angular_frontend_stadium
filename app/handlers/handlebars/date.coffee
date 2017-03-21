moment = require('moment')

module.exports = (timestamp) ->
  moment(timestamp).format 'MMMM D, YYYY'
