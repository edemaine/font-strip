window?.onload = ->
  font = decodeFont fontEnc
  makeSVG = =>
    svg = SVG().addTo '#surface'
    updateStyles [svg]
    svg
  showUnfolded makeSVG(), font[true]
  showFolded makeSVG(), font[true]
  showUnfolded makeSVG(), font[false]
  showFolded makeSVG(), font[false]
