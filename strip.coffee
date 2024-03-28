margin = 0.5
outerStroke =
  color: 'black'
  width: 0.2
  linejoin: 'round'
paperFill = (a) ->
  "rgba(255,245,109,#{a})"
  #'rgba(255,245,109,0.5)' #cmyk(0,0,70%,0)
  #'rgba(255,255,204,0.5)' #'#ffffcc'
creaseStroke =
  color: 'purple'
  width: 0.1
gridStroke =
  color: '#dddddd'
  width: 0.05

## Additional characters:
##  - @ after ~ rotates the character when prefix is missing
##    (sometimes characters get reversed, so also appears before ~)
##  - |~| is a good trick for flipping when prefix is missing
##  - # vertically flips all following commands; use at end to indicate strip
##    (and #~# if you need to flip when suffix is missing)
##    is now upside-down
fontEnc =
  A: '_~/___/_\\_/__|___|/_\\~_'
  B: '_~/___/_\\_/__|__/_\\__#@@~#|____'
  C: '_/___/_\\_|~@@@_/_\\___/_\\_@@@~|_\\_'
  D: '_~/____|/_/___\\__#@@~#|____'
  #E: '_/___/__|~@@__\\_/__|__/_\\__~_'
  E: '_/___/__~|@@__\\_/__|__/_\\__~/|/#'
  F: '_/___/__~|@@__\\_/__|__/_\\~\\|\\#__'
  G: '_/___/__~|@@__\\___/_\\_|#@~#_\\_'
  H: '_~/____|__/_\\__|____\\~_'
  I: '_~/____#@@@~#|____/#_'
  #Istart: '~@____/~#_'
  J: '_/_|~@_/_\\____@@@~|____\\_'
  K: '_~/____|__/\\\\\\_|_//_\\\\\\~_'
  #L: '_/____|~@_____|\\|___~/|/'
  #L: '\\|\\\\____~@@@|_____|/|___~\\|\\'
  L: ' /|~@|    |    /  #~#/|/'
  M: '_~/___/\\_\\/_/\\___\\~_'
  N: '_~/____|_///\\__|____\\~_'
  O: '_/~@___/_\\___/_\\#@@@~#|/_\\|\\_'
  Ostart: '~@\\_/___\\_/___~/#_'
  P: '_~/___/_\\_/_/#@~#_\\___'
  Q: '/|~@/_\\___/_\\___/_//#~#\\\\#'
  #R: '_~/___/_\\_/__|_////~_#'
  R: '_~/___/_\\_/_|////#~_'
  #S: '_~__/_\\_\\_/__|__\\_/_/_~/#_'
  S: '_\\|~@@@\\_\\_/_/_\\_/@~|\\_/_\\_\\_\\_'
  T: '__~/___\\_|___#~#|_/___\\__'
  Tstart: '__/~@@@___\\_|___|_/___/#~__'
  U: '_/____|~@____/_\\____@@@~|____\\_'
  V: '_/____|~@____//|//____#@@@~#|____/#_'
  W: '_/____|~@____/\\_\\/_/\\____@@@~|____\\_'
  X: '_~///_\\\\_|_///\\\\\\_|_//_\\\\\\~_'
  #X2: '@_//_\\\\_|_///\\\\\\_|_//_\\\\_|_'
              #(there is a fold used for joining  this shows without fold)
  Y: '__~/_\\\\__|__//|//__#@@@~#|__\\\\_/#__'
  #Z: '\\|\\|~|_|\\__|/__|\\__|\\__|__\\_/_/_\\__~\\|\\'  # like 2
  Z: '\\|\\\\ \\\\\\\\/  |~   |\\\\\\\\\\  |/  ~\\|\\#'  # 3 wide
  #Z: '\\|\\|~@@|_|\\_////_|\\__|__\\////_\\__~\\|\\'  # 3 wide ending
  #Z: '\\|\\|~@@|_|\\//_//_|\\__|__\\//_//\\__\\|\\'  # weird 3 wide
  #Z: '\\|\\|~@@|_|\\//////_|\\___|___\\//////\\___~\\|\\'  # 4 wide
  #'1': '\\|\\~_|\\____~|____//|/'
             #(upside down T)
  '1': '_\\|\\|~@@|_|\\____|\\\\@~|/\\___\\\\|\\#'
  '2': '_/_/_/_\\__~@@|__/_\\_\\_/__#~#/|/'
  '3': '_\\|\\#~#__\\_/__|__/_\\__@@~|__/___/#_'
  '4': '___~/_\\_\\__|__/_\\__|____\\~_'
  #'5': '_/__|/__|\\~@__|\\__|__\\_/_/__|/|___' -- reflected
  #'5': '___/_\\_\\_/__|___|\\_\\_\\__|\\_'
  #'5': '_~\\|\\_\\_/_/_\\__|___|/__|/__|\\__|/~_'
  #'5': '_~__/__|\\__|/__|/__|__/_\\_\\__|\\~_'
  #'5': '\\|\\|~|___|\\_\\_\\__|/__~|__/_\\_\\_\\_'
  '5': '_\\|\\|~@@|__|\\_\\_\\__|/__#~#|__/_\\_\\_\\_'
  '6': '_/|~@|____|__/_/_\\_/|\\_~/|/#_'
  '7': '___~/___\\__|#~#__/___/#_'
  '8': '_/|~@/|\\_/_/_\\_/_\\_\\_/_@@~|_\\|\\_'
  '9': '___~/_\\_\\_/_\\__#@~#_\\_'
  '0': '_/#~@@@#___/_\\___/_\\#@@@~#|/_\\|\\_'
  #b: '_/_/_/__|____\\_/|\\_/|/_'
  #'THE': '___|_\\___\\|/|/__\\____|__\\_/__|____/_\\___\\__|__/_\\_|_\\_/__~'
  #'THE END': '___|_\\___\\|/|/__\\____|__\\_/__|____/_\\___\\__|__/_\\_|_\\_/__/|/_____\\|___\\__|__/_\\_|_\\_/__/|//____|_////|___|____/_\\____|\\_\\___/__|~'
  #http://erikdemaine.org/fonts/strip/design.html?cp=___|_\___\|/|/__\____|__\_/__|____/_\___\__|__/_\_|_\_/__/|/_____\|___\__|__/_\_|_\_/__/|//____|_////|___|____/_\____|\_\___/__|
  ' ': '~___~'  ## one of these gets stripped off

parseEnc = (s, continuous) ->
  if continuous
    s = s.replace /~/g, ''
  else if 0 <= (i1 = s.indexOf '~')
    if i1 == (i2 = s.lastIndexOf '~')
      ## If only one ~, remove the part before it.
      s = s[i1+1..]
    else
      ## If multiple tildes, remove parts before first and after last,
      ## but ignore any in between.
      s = s[i1+1...i2].replace /~/g, ''

  rotate = 0
  while s.length > 0 and s[0] == '@'
    rotate += 1
    s = s[1..]
  s = s.replace /@/g, ''
  ## Two immediate vertical folds do nothing together, and don't want to draw
  ## them.  Useful to say |~|, so an initial fold if beginning, nothing else.
  s = s.replace /\|\|/g, ''

  x = 0
  creases = [
    xb: 0
    xt: 0
  ]
  flipped = false
  for c in s
    switch c
      when ' '
        x += 2
      when '_'
        x += 2
      when '!'
        x += 1
      when '|'
        creases.push
          xb: x
          xt: x
      when '/', '\\'
        if (c == '\\') == flipped  ## / unflipped or \ flipped
          creases.push
            xb: x
            xt: x+2
        else                       ## \ unflipped or / flipped
          creases.push
            xb: x+2
            xt: x
        x += 2
      when '#'
        flipped = not flipped
  creases.push
    xb: x
    xt: x

  creases: creases
  width: x
  height: 2
  yb: 2
  yt: 0
  rotate: rotate

makePoint = (x, y) ->
  x: x
  y: y

reflectPoint = (point, line) ->
  v = ## b-a
    x: line.b.x - line.a.x
    y: line.b.y - line.a.y
  vp = ## (b-a) perp
    x: -v.y
    y: v.x
  vpnorm = vp.x * vp.x + vp.y * vp.y
  dot = vp.x * (point.x - line.a.x) + vp.y * (point.y - line.a.y)
  x: point.x - 2 * vp.x * dot / vpnorm
  y: point.y - 2 * vp.y * dot / vpnorm

reflectPolygon = (polygon, line) ->
  for point in polygon
    reflectPoint point, line

rotatePoint = (point) ->
  #makePoint point.y, -point.x
  makePoint -point.y, point.x

rotatePolygon = (polygon) ->
  for point in polygon
    rotatePoint point

foldStrip = (letter) ->
  xb = letter.creases[0].xb
  xt = letter.creases[0].xt
  i = 0
  for crease in letter.creases[1..]
    i += 1
    polygon = [
      makePoint xt, letter.yt
      makePoint xb, letter.yb
      makePoint crease.xb, letter.yb
      makePoint crease.xt, letter.yt
    ]
    xb = crease.xb
    xt = crease.xt
    #console.log i, letter.creases[1...i].reverse()
    for c2 in letter.creases[1...i].reverse()
      polygon = reflectPolygon polygon,
        a: makePoint c2.xt, letter.yt
        b: makePoint c2.xb, letter.yb
    for r in [0...letter.rotate]
      polygon = rotatePolygon polygon
    polygon

decodeFont = (fontEnc) ->
  font = {}
  for continuous in [true, false]
    font[continuous] = {}
    for c, enc of fontEnc
      font[continuous][c] = parseEnc enc, continuous
      font[continuous][c].folded = foldStrip font[continuous][c]
  font

autobox = (svg) ->
  bbox = svg.bbox()
  bbox.x -= margin
  bbox.y -= margin
  bbox.width += 2 * margin
  bbox.height += 2 * margin
  #console.log bbox.x, bbox.y, bbox.width, bbox.height
  svg.viewbox bbox

fontLetters = (font) ->
  ## Singleton case if not an object mapping characters to symbols
  return [font] if font.creases? or Array.isArray font
  cs = (c for c of font)
  cs.sort (x, y) ->
    x = 'n' + x if 48 <= x.charCodeAt(0) <= 57
    y = 'n' + y if 48 <= y.charCodeAt(0) <= 57
    if x < y
      -1
    else if x > y
      +1
    else
      0
  font[c] for c in cs

showUnfolded = (svg, font) ->
  y = 0
  for letter in fontLetters font
    g = svg.group()
    g.translate 0, y

    g.rect letter.width, letter.height
    .addClass 'paper'
    .stroke 'rgba(0,0,0,0)' # avoid 'stroke: none' warning in Origami Simulator

    for x in [1...letter.width]
      if x % 2 == 0
        g.line x, letter.yt, x, letter.yb
        .stroke gridStroke

    for crease in letter.creases
      g.line crease.xt, letter.yt, crease.xb, letter.yb
      .stroke creaseStroke

    g.rect letter.width, letter.height
    .stroke outerStroke
    .fill 'none'

    y += 3
  autobox svg

showUnfoldedSquare = (svg, font) ->
  y = 0
  for letter in fontLetters font
    square = letter.height * Math.ceil 1 + Math.sqrt letter.width / letter.height - 1
    g = svg.group()
    g.translate 0, y

    g.rect square, square
    .addClass 'paper'
    .stroke 'rgba(0,0,0,0)' # avoid 'stroke: none' warning in Origami Simulator

    for x in [1...square]
      if x % 2 == 0
        g.line x, 0, x, square
        .stroke gridStroke
    for y in [1...square]
      if y % 2 == 0
        if y % 4 == 0
          g.line 0, y, letter.height, y
          .stroke gridStroke
          g.line letter.height, y, square, y
          .stroke outerStroke
        else
          g.line square - letter.height, y, square, y
          .stroke gridStroke
          g.line 0, y, square - letter.height, y
          .stroke outerStroke

    yOffset = 0
    xOffset = 0
    flip = (x) =>
      if yOffset % 4 == 2
        square - x
      else
        x
    drawCrease = (x1, y1, x2, y2) =>
      if yOffset % 4 == 2
        x1 = square - x1
        x2 = square - x2
        [y1, y2] = [y2, y1]
      g.line x1, y1, x2, y2
      .stroke creaseStroke
    afterTurn = null
    creases = letter.creases[..]
    if (lastCrease = creases.at -1)
      x = Math.max lastCrease.xt, lastCrease.xb
      ## Last crease is generally a vertical.
      if lastCrease.xt == lastCrease.xb
        prevCrease = creases.at -2
      else
        prevCrease = lastCrease
      diag = 0
      if prevCrease?.xt == x
        diag = 1
      else if prevCrease?.xb == x
        diag = -1
      total = 2 * (square/2 * (square/2 - 2) + 2)
      while x < total
        if diag == 1
          creases.push {xt: x, xb: x+2}
        else if diag == -1
          creases.push {xt: x+2, xb: x}
        x += 2
        break unless x < total
        creases.push {xt: x, xb: x}
        diag = -diag
    for crease in creases
      limit = if yOffset in [0, square-2] then square-2 else square-4
      {xt, xb} = crease
      xt += xOffset
      xb += xOffset
      while xt > limit or xb > limit
        ## Crease just beyond limit. Mirror it into the wraparound pixels.
        if xt == limit
          drawCrease square-2, yOffset, square, yOffset+2
          afterTurn = =>
            drawCrease square-2, yOffset+4, square, yOffset+2
        else if xb == limit
          drawCrease square, yOffset, square-2, yOffset+2
          afterTurn = =>
            drawCrease square, yOffset+4, square-2, yOffset+2
        #drawCrease square-2, yOffset, square-2, yOffset+2
        drawCrease square-2, yOffset+2, square, yOffset+2
        afterTurn?()
        afterTurn = null
        drawCrease square-2, yOffset+2, square-2, yOffset+4
        xOffset -= limit
        xt -= limit
        xb -= limit
        yOffset += 2
        limit = if yOffset in [0, square-2] then square-2 else square-4
      if yOffset
        xt += 2
        xb += 2
        limit += 2
      {yt, yb} = letter
      yt += yOffset
      yb += yOffset
      ## Crease just reaches limit. This is actually on previous pixel,
      ## not wraparound pixel, so we don't need to mirror it.
      #if yOffset < square-2
      #  if xt == limit and xb != limit
      #    drawCrease square-2, yOffset, square, yOffset+2
      #    afterTurn = =>
      #      drawCrease square-2, yOffset+4, square, yOffset+2
      #  else if xt != limit and xb == limit
      #    drawCrease square, yOffset, square-2, yOffset+2
      #    afterTurn = =>
      #      drawCrease square, yOffset+4, square-2, yOffset+2
      drawCrease xt, yt, xb, yb

    g.rect square, square
    .stroke outerStroke
    .fill 'none'

    y += square + 1
  autobox svg

showFolded = (svg, font) ->
  i = x = y = 0
  for letter in fontLetters font
    g = svg.group()
    for polygon in letter.folded ? letter
      poly = ([point.x, point.y] for point in polygon)
      g.polygon poly
      .stroke outerStroke
      .addClass 'paper'
    bbox = g.bbox()
    g.translate x - bbox.x, y - bbox.y
    x += bbox.width + 2
    i += 1
    if i == 6
      i = x = 0
      y += bbox.height + 2
  autobox svg

## Based on jolly.exe's code from http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript
getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp "[\\?&]" + name + "=([^&#]*)"
  results = regex.exec location.search
  if results == null
    null
  else
    decodeURIComponent results[1].replace(/\+/g, " ")

updateStyles = (svgs) ->
  rules = []
  ## Thanks to Una Kravets for pointing out that mix-blend-mode:multiply
  ## works better with alpha values than with fill-opacity.
  #rules.push ".paper { fill-opacity: #{document.getElementById('opacity')?.value ? 50}% }"
  rules.push ".paper { fill: #{paperFill "#{document.getElementById('opacity')?.value ? 50}%"} }"
  if document.getElementById('backlight')?.checked
    rules.push '.paper { mix-blend-mode: multiply }'
  else
    rules.push '.paper { mix-blend-mode: normal }'
  if shadow = document.getElementById('shadow')?.valueAsNumber
    r = 255/100 * (100 - shadow)
    rules.push ".paper { filter: drop-shadow(0px 0px 0.3px rgb(#{r} #{r} #{r})) }"
  rules = rules.join '\n'
  for svg in svgs when svg?
    unless svg.styleTag?.node.parentNode?
      svg.styleTag = undefined
    svg.styleTag ?= svg.element 'style'
    svg.styleTag.words rules

cleanupSVG = (svg) -> svg.replace /\sid="[^"]*"/g, ''
simulateSVG = (svg) ->
  parity = true
  cleanupSVG(svg.svg())
  .replace ///#{creaseStroke.color}///g, ->
    parity = not parity
    if parity
      '#f00'
    else
      '#00f'
  .replace ///(<line[^<>/]*)#{outerStroke.color}///g, "$1#0f0"
  #.replace ///(<line[^<>/]*)#{gridStroke.color}///g, "$1#ff0"
  .replace ///<line[^<>/]*#{gridStroke.color}[^<>/]*(/>|>\s*</line>)///g, ''
  .replace ///<rect[^<>/]*class="paper[^<>/]*(/>|>\s*</rect>)///, ''

download = (svg, filename) ->
  document.getElementById('download').href = URL.createObjectURL \
    new Blob [svg], type: "image/svg+xml"
  document.getElementById('download').download = filename
  document.getElementById('download').click()

downloadButtons = (unfolded, folded) ->
  document.getElementById('downloadCP')?.addEventListener 'click', ->
    download cleanupSVG(unfolded.svg()), 'strip-unfolded.svg'
  document.getElementById('downloadFolded')?.addEventListener 'click', ->
    download cleanupSVG(folded.svg()), 'strip-folded.svg'
  document.getElementById('downloadSim')?.addEventListener 'click', ->
    download simulateSVG(unfolded), 'strip-simulate.svg'
  document.getElementById('simulate')?.addEventListener 'click', ->
    simulate simulateSVG unfolded

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
simulate = (svg) ->
  if simulator? and not simulator.closed
    simulator.focus()
  else
    ready = false
    #simulator = window.open 'OrigamiSimulator/?model=', 'simulator'
    simulator = window.open 'https://origamisimulator.org/?model=', 'simulator'
  onReady = -> simulator.postMessage
    op: 'importSVG'
    svg: svg
    vertTol: 0.1
    filename: 'strip-simulate.svg'
  , '*'
  checkReady()

window?.fontEnc = fontEnc
window?.showFolded = showFolded
window?.showUnfolded = showUnfolded
window?.showUnfoldedSquare = showUnfoldedSquare
window?.parseEnc = parseEnc
window?.decodeFont = decodeFont
window?.foldStrip = foldStrip
window?.getParameterByName = getParameterByName
window?.updateStyles = updateStyles
window?.creaseStroke = creaseStroke
window?.gridStroke = gridStroke
window?.cleanupSVG = cleanupSVG
window?.simulateSVG = simulateSVG
window?.download = download
window?.downloadButtons = downloadButtons
window?.simulate = simulate

#console.log reflectPoint
#  x: 1
#  y: 0
#,
#  a:
#    x: -1
#    y: -1
#  b:
#    x: 1
#    y: 1
#
#console.log reflectPoint
#  x: 8
#  y: 0
#,
#  a:
#    x: 8
#    y: 0
#  b:
#    x: 10
#    y: 2
