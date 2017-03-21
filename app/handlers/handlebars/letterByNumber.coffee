module.exports = (orderName) ->
  if orderName
    orderName.replace(/[^a-zA-Z]+/g, '')
