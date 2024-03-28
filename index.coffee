###
TODO:
* Cut out of rectangle of paper like http://whyh7.blogspot.com/2010/04/font-design-strip-folding.html
  * Vertical strips seem best
  * Easy form is to attach the strip at the base, and just start off with a
    turn gadget, then use the prefix (starting from rightward horizontal)
    + middle of the existing font.
  * Drop shadows would be ideal to separate background from strips
  * Background rectangle with slits a different color?
* In the two views above, could resize strip width based on small or capital
  letters -- like a small caps font
* Also a laser cut mode to make both of these
###

#charKern = 15
#lineKern = 30
#charSpace = 50
#margin = 10

folded = unfolded = null
stripHeight = 50  ## px

update = (changed) ->
  return updateStyle() unless changed.text or changed.left or changed.mirror or changed.paper
  resize()
  state = @getState()

  unfolded.clear()
  folded.clear()
  lines = []
  lines = state.text.split '\n'
  while lines.length > 0 and lines[0].length == 0
    lines.shift()
  while lines.length > 0 and lines[lines.length-1].length == 0
    lines.pop()
  parity = Number state.left
  enc = (for line, row in lines
    lineEnc = (for char, col in line
      char = char.toUpperCase()
      if char of fontEnc
        if row == col == 0 and "#{char}start" of fontEnc and not state.left
          char = "#{char}start"
        fontEnc[char].replace /^[ _]/, ''
      else
        continue
    ).join ''
    if row % 2 == 1 - parity
      if state.mirror
        lineEnc = "#_#{lineEnc}#"
      else
        lineEnc = lineEnc.split('').reverse().join('')
    if row < lines.length - 1
      if row % 2 == parity
        lineEnc += '\\_____/'
      else
        lineEnc += '_/_____\\_'
    lineEnc
  ).join ''
  if state.left
    index = enc.indexOf '~'
    index++ while enc[index+1] == '@'
    enc = "#{enc[..index]}#{if state.mirror then '' else '#'}|#{enc[index+1..]}"
  parsed = parseEnc enc, false
  document.getElementById('aspectRatio')?.innerHTML = aspectRatio =
    parsed.width / parsed.height
  document.getElementById('squareDim1')?.innerHTML =
  document.getElementById('squareDim2')?.innerHTML =
    Math.ceil 1 + Math.sqrt aspectRatio - 1
  switch state.paper
    when 'strip'
      showUnfolded unfolded, parsed
    when 'square'
      showUnfoldedSquare unfolded, parsed
  showFolded folded, foldStrip parsed
  bbox = unfolded.viewbox()
  if state.paper == 'strip'
    unfolded.width "#{stripHeight * bbox.width / bbox.height}px"
    unfolded.height "#{stripHeight}px"
  else
    unfolded.width null
    unfolded.height null
  updateStyle()

updateStyle = ->
  updateStyles [unfolded, folded]

## Based on meouw's answer on http://stackoverflow.com/questions/442404/retrieve-the-position-x-y-of-an-html-element
getOffset = (el) ->
  x = y = 0
  while el and not isNaN(el.offsetLeft) and not isNaN(el.offsetTop)
    x += el.offsetLeft - el.scrollLeft
    y += el.offsetTop - el.scrollTop
    el = el.offsetParent
  x: x
  y: y

resize = ->
  offset = getOffset document.getElementById 'output'
  height = Math.max 100, window.innerHeight - offset.y
  document.getElementById('output').style.height = "#{height}px"

window?.onload = ->
  unfolded = SVG().addTo '#unfolded'
  folded = SVG().addTo '#folded'
  #loadFont()

  furls = new Furls()
  .addInputs()
  .on 'stateChange', update
  .syncState()
  .syncClass()

  window.addEventListener 'resize', resize
  resize()

  document.getElementById("fontLinks").innerHTML = (
    for char in (key for key of window.fontEnc).sort()
      continue if char == ' '
      """<A HREF="design.html?cp=#{window.fontEnc[char]}">#{char.replace /start/, ' (start)'}</A>"""
  ).join ", "

  downloadButtons unfolded, folded
