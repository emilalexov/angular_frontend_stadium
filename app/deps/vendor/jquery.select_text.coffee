$.fn.selectText = ->

  doc = document
  el = @[0]

  if doc.body.createTextRange
    range = document.body.createTextRange()
    range.moveToElementText(el)
    range.select()
  else if window.getSelection
    selection = window.getSelection()
    range = document.createRange()
    range.selectNodeContents(el)
    selection.removeAllRanges()
    selection.addRange(range)

  return
