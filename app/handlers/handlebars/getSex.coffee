module.exports = (gender, options) ->
  map =
    false: 'Female'
    true: 'Male'
  map[gender]
