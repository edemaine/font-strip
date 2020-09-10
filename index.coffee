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

checkboxes = ['mirror']
loadState = ->
  for checkbox in checkboxes
    document.getElementById(checkbox).checked = getParameterByName checkbox
  text = getParameterByName('text') ? 'text'
  document.getElementById('text').value = text
  document.getElementById('opacity')?.value = parseInt getParameterByName('opacity') ? 50
  document.getElementById('backlight')?.checked = getParameterByName 'backlight'
  update false

old = {}
update = (setURL = true) ->
  params = {}
  params.text = document.getElementById('text').value
    .replace(/\r\n/g, '\r').replace(/\r/g, '\n')
  for checkbox in checkboxes
    params[checkbox] = document.getElementById(checkbox).checked
  #updateCheckboxes()
  unchanged = (true for key of params when params[key] != old[key]).length == 0
  setUrl params, unchanged if setURL
  return updateStyle() if unchanged
  old = params

  unfolded.clear()
  unfolded.style = unfolded.element 'style'
  folded.clear()
  folded.style = folded.element 'style'
  lines = []
  lines = params.text.split '\n'
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
      if params.mirror
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

#updateCheckboxes = ->
#  for checkbox in checkboxes
#    checked = document.getElementById(checkbox).checked
#    if negated[checkbox]
#      checked = not checked
#      checkbox = "no#{checkbox}"
#    if checked
#      svg.addClass checkbox
#    else
#      svg.removeClass checkbox

setUrl = (params, replace = true) ->
  encoded =
    for key, value of params
      if value == true
        value = '1'
      else if value == false
        continue
      "#{key}=#{encodeURIComponent(value).replace /%20/g, '+'}"
  url = "#{document.location.pathname}?#{encoded.join '&'}"
  opacity = document.getElementById('opacity')?.value ? '50'
  url += "&opacity=#{opacity}" unless opacity == '50'
  url += '&backlight=1' if document.getElementById('backlight')?.checked
  if replace
    history.replaceState null, 'style', url
  else
    history.pushState null, 'text', url

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

fontGui = ->
  unfolded = SVG 'unfolded'
  unfolded.height "#{unfoldedHeight}px"
  folded = SVG 'folded'
  #loadFont()

  updateSoon = (event) ->
    setTimeout update, 0
    true
  for event in ['input', 'propertychange', 'keyup']
    document.getElementById('text').addEventListener event, updateSoon
  for event in ['input', 'propertychange', 'click']
    for checkbox in checkboxes
      document.getElementById(checkbox).addEventListener event, updateSoon
  document.getElementById('backlight')?.addEventListener 'input', updateSoon
  document.getElementById('opacity')?.addEventListener 'input', updateSoon

  window.addEventListener 'popstate', loadState
  window.addEventListener 'resize', resize
  loadState()
  resize()

  document.getElementById("fontLinks").innerHTML = (
    for char in (key for key of window.fontEnc).sort()
      continue if char == ' '
      """<A HREF="design.html?cp=#{window.fontEnc[char]}">#{char.replace /start/, ' (start)'}</A>"""
  ).join ", "

  cleanup = (svg) -> svg.replace /\sid="[^"]*"/g, ''
  download = (svg, filename) ->
    document.getElementById('download').href = URL.createObjectURL \
      new Blob [svg], type: "image/svg+xml"
    document.getElementById('download').download = filename
    document.getElementById('download').click()
  document.getElementById('downloadCP')?.addEventListener 'click', ->
    download cleanup(unfolded.svg()), 'strip-unfolded.svg'
  document.getElementById('downloadFolded')?.addEventListener 'click', ->
    download cleanup(folded.svg()), 'strip-folded.svg'
  simulateSVG = ->
    parity = true
    cleanup(unfolded.svg())
    .replace ///#{creaseStroke.color}///g, ->
      parity = not parity
      if parity
        '#f00'
      else
        '#00f'
    .replace ///<line[^<>/]*#{gridStroke.color}[^<>/]*(/>|>\s*</line>)///g, ''
    .replace ///<rect[^<>/]*fill="[r#][^<>/]*(/>|>\s*</rect>)///, ''
  document.getElementById('downloadSim')?.addEventListener 'click', ->
    download simulateSVG(), 'strip-simulate.svg'

  ## Origami Simulator
  simulator = null
  ready = false
  onReady = null
  checkReady = ->
    if ready
      onReady?()
      onReady = null
  window.addEventListener 'message', (e) ->
    if e.data and e.data.from == 'OrigamiSimulator' and e.data.status == 'ready'
      ready = true
      checkReady()
  document.getElementById('simulate')?.addEventListener 'click', ->
    if simulator? and not simulator.closed
      simulator.focus()
    else
      ready = false
      simulator = window.open 'OrigamiSimulator/?model=', 'simulator'
    svg = simulateSVG()
    onReady = -> simulator.postMessage
      op: 'importSVG'
      svg: svg
      vertTol: 0.1
      filename: 'strip-simulate.svg'
    checkReady()

window?.onload = fontGui
