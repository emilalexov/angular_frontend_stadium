module.exports = (number) ->
  colors = [
    '#38cb73'
    '#389adb'
    '#fed929'
    '#e54d40'
    '#e459fe'
  ]
  colors[number % colors.length]
