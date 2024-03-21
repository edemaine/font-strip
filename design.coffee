unfold1 = unfold2 = fold1 = fold2 = null

update = (changed) ->
  return updateStyle() unless changed.cp
  state = @getState()
  font = decodeFont x: state.cp
  document.getElementById('aspectRatioWith')?.innerHTML = font.true.x.width / font.true.x.height
  document.getElementById('aspectRatioWithout')?.innerHTML = font.false.x.width / font.false.x.height
  #console.log ':', state.cp, font
  unfold1.clear()
  fold1.clear()
  showUnfolded unfold1, font[true]
  showFolded fold1, font[true]
  if unfold2?
    unfold2.clear()
    showUnfolded unfold2, font[false]
  if fold2?
    fold2.clear()
    showFolded fold2, font[false]
  updateStyle()

updateStyle = -> updateStyles [unfold1, unfold2, fold1, fold2]

window?.onload = ->
  unfold1 = SVG().addTo '#unfold1'
  unfold2 = SVG().addTo '#unfold2' if document.getElementById 'unfold2'
  fold1 = SVG().addTo '#fold1'
  fold2 = SVG().addTo '#fold2' if document.getElementById 'fold2'

  furls = new Furls()
  .addInputs()
  .configInput 'cp',
    encode: (cp) => cp.replace /[ ]/g, '_'
    decode: (cp) => cp.replace /_/g, ' '
  .on 'stateChange', update
  .syncState()
  #.syncClass()

  resize = ->
    gui = document.getElementById('gui')
    gui.style.height = Math.max(Math.floor(window.innerHeight - gui.getBoundingClientRect().top - 50), 100) + 'px'
  window.addEventListener 'resize', resize
  resize()

  downloadButtons unfold1, fold1
