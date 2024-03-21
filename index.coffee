###
TODO:
* Fold superlong strip from a slit square of paper
  * Spiral or zig-zag options
  * Need to compose turn gadgets (to straighten out strip) with other folds
    (which I think might lead to crossing folds)
  * Ideally able to specify a segment (prefix or suffix) that's folded,
    and rest is unfolded (e.g. slash in text? HELLO/WORLD)
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
unfoldedHeight = 50  ## px

update = (changed) ->
  return updateStyle() unless changed.text or changed.mirror
  state = @getState()

  unfolded.clear()
  folded.clear()
  lines = []
  lines = state.text.split '\n'
  while lines.length > 0 and lines[0].length == 0
    lines.shift()
  while lines.length > 0 and lines[lines.length-1].length == 0
    lines.pop()
  enc = (for line, row in lines
    lineEnc = (for char, col in line
      char = char.toUpperCase()
      if char of fontEnc
        if row == col == 0 and "#{char}start" of fontEnc
          char = "#{char}start"
        fontEnc[char].replace /^[ _]/, ''
      else
        continue
    ).join ''
    if row % 2 == 1
      if state.mirror
        lineEnc = "#_#{lineEnc}#"
      else
        lineEnc = lineEnc.split('').reverse().join('')
    if row < lines.length - 1
      if row % 2 == 0
        lineEnc += '\\_____/'
      else
        lineEnc += '_/_____\\_'
    lineEnc
  ).join ''
  parsed = parseEnc enc, false
  document.getElementById('aspectRatio')?.innerHTML = parsed.width / parsed.height
  showUnfolded unfolded, parsed
  showFolded folded, foldStrip parsed
  bbox = unfolded.viewbox()
  unfolded.width "#{unfoldedHeight * bbox.width / bbox.height}px"
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
  offset = getOffset document.getElementById 'folded'
  height = Math.max 100, window.innerHeight - offset.y
  document.getElementById('folded').style.height = "#{height}px"

window?.onload = ->
  unfolded = SVG().addTo '#unfolded'
  unfolded.height "#{unfoldedHeight}px"
  folded = SVG().addTo '#folded'
  #loadFont()

  furls = new Furls()
  .addInputs()
  .on 'stateChange', update
  .syncState()
  #.syncClass()

  window.addEventListener 'resize', resize
  resize()

  document.getElementById("fontLinks").innerHTML = (
    for char in (key for key of window.fontEnc).sort()
      continue if char == ' '
      """<A HREF="design.html?cp=#{window.fontEnc[char]}">#{char.replace /start/, ' (start)'}</A>"""
  ).join ", "

  downloadButtons unfolded, folded
