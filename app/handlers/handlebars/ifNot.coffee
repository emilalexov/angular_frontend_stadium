module.exports = (v1, v2, options) ->
  if v1 is v2
    options.inverse @
  else
    options.fn @
