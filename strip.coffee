margin = 0.2
outerStroke =
  color: 'black'
  width: 0.2
  linejoin: 'round'
paperFill =
  'rgba(255,245,109,0.5)' #cmyk(0,0,70%,0)
  #'rgba(255,255,204,0.5)' #'#ffffcc'
creaseStroke =
  color: 'purple'
  width: 0.1
gridStroke =
  color: '#dddddd'
  width: 0.05

## Additional characters:
##  - @ after ~ rotates the character when prefix is missing
##  - |~| is a good trick for flipping when prefix is missing
##  - # vertically flips all following commands; use at end to indicate strip
##    is now upside-down
fontEnc =
  A: '_~/___/_\\_/__|___|/_\\~_'
  B: '_~/___/_\\_/__|__/_\\__~|____'
  C: '_/___/_\\_|~@@@_/_\\___/_\\_~|_\\_'
  D: '_~/____|/_/___\\__~|____'
  #E: '_/___/__|~@@__\\_/__|__/_\\__~_'
  E: '_/___/__~|@@__\\_/__|__/_\\__/|/~#'
  F: '_/___/__~|@@__\\_/__|__/_\\~\\|\\#__'
  G: '_/___/__~|@@__\\___/_\\_|~~_\\_'
  H: '_~/____|__/_\\__|____\\~_'
  I: '_~/____~|____/#_'
  #Istart: '~@____/~#_'
  J: '_/_|~@_/_\\____~|____\\_'
  K: '_~/____|__/\\\\\\_|_//_\\\\\\~_'
  #L: '_/____|~@_____|\\|___~/|/'
  #L: '\\|\\\\____~@@@|_____|/|___~\\|\\'
  L: ' /|~@|    |    /  ~/|/'
  M: '_~/___/\\_\\/_/\\___\\~_'
  N: '_~/____|_///\\__|____\\~_'
  O: '_/~@___/_\\___/_\\~|/_\\|\\_'
  Ostart: '~@\\_/___\\_/___~/#_'
  P: '_~/___/_\\_/_/~_\\___'
  Q: '/|~@/_\\___/_\\___/_//~\\\\#'
  #R: '_~/___/_\\_/__|_////~_#'
  R: '_~/___/_\\_/_|////~#_'
  #S: '_~__/_\\_\\_/__|__\\_/_/_~/#_'
  S: '_\\|~@@@\\_\\_/_/_\\_/~|\\_/_\\_\\_\\_'
  T: '__~/___\\_|___~|_/___\\__'
  Tstart: '__/~@@@___\\_|___|_/___/#~__'
  U: '_/____|~@____/_\\____~|____\\_'
  V: '_/____|~@____//|//____~|____/#_'
  W: '_/____|~@____/\\_\\/_/\\____~|____\\_'
  X: '_~///_\\\\_|_///\\\\\\_|_//_\\\\\\~_'
  #X2: '@_//_\\\\_|_///\\\\\\_|_//_\\\\_|_'
              #(there is a fold used for joining  this shows without fold)
  Y: '__~/_\\\\__|__//|//__~|__\\\\_/#__'
  #Z: '\\|\\|~|_|\\__|/__|\\__|\\__|__\\_/_/_\\__~\\|\\'  # like 2
  Z: '\\|\\\\ \\\\\\\\/  |~   |\\\\\\\\\\  |/  ~\\|\\#'  # 3 wide
  #Z: '\\|\\|~@@|_|\\_////_|\\__|__\\////_\\__~\\|\\'  # 3 wide ending
  #Z: '\\|\\|~@@|_|\\//_//_|\\__|__\\//_//\\__\\|\\'  # weird 3 wide
  #Z: '\\|\\|~@@|_|\\//////_|\\___|___\\//////\\___~\\|\\'  # 4 wide
  #'1': '\\|\\~_|\\____~|____//|/'
             #(upside down T)
  '1': '_\\|\\|~@@|_|\\____|\\\\~|/\\___\\\\|\\#'
  '2': '_/_/_/_\\__~|__/_\\_\\_/__~/|/'
  '3': '_\\|\\~__\\_/__|__/_\\__~|__/___/#_'
  '4': '___~/_\\_\\__|__/_\\__|____\\~_'
  #'5': '_/__|/__|\\~@__|\\__|__\\_/_/__|/|___' -- reflected
  #'5': '___/_\\_\\_/__|___|\\_\\_\\__|\\_'
  #'5': '_~\\|\\_\\_/_/_\\__|___|/__|/__|\\__|/~_'
  #'5': '_~__/__|\\__|/__|/__|__/_\\_\\__|\\~_'
  #'5': '\\|\\|~|___|\\_\\_\\__|/__~|__/_\\_\\_\\_'
  '5': '_\\|\\|~|__|\\_\\_\\__|/__~|__/_\\_\\_\\_'
  '6': '_/|~@|____|__/_/_\\_/|\\_~/|/#_'
  '7': '___~/___\\__|~__/___/#_'
  '8': '_/|~@/|\\_/_/_\\_/_\\_\\_/_~|_\\|\\_'
  '9': '___~/_\\_\\_/_\\__~_\\_'
  '0': '_/~@___/_\\___/_\\~|/_\\|\\_'
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
      s = s.split('~')[1]
    else
      ## If multiple tildes, remove parts before first and after last,
      ## but ignore any in between.
      s = s[i1+1...i2].replace /~/g, ''

  rotate = 0
  while s.length > 0 and s[0] == '@'
    rotate += 1
    s = s[1..]
  s = s.replace /@/, ''
  ## Two immediate vertical folds do nothing together, and don't want to draw
  ## them.  Useful to say |~|, so an initial fold if beginning, nothing else.
  s = s.replace /||/g, ''

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
    .fill paperFill

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

showFolded = (svg, font) ->
  i = x = y = 0
  for letter in fontLetters font
    g = svg.group()
    for polygon in letter.folded ? letter
      poly = ([point.x, point.y] for point in polygon)
      g.polygon poly
      .stroke outerStroke
      .fill paperFill
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

designer = ->
  lastcp = null
  unfold1 = SVG 'unfold1'
  unfold2 = SVG 'unfold2' if document.getElementById 'unfold2'
  fold1 = SVG 'fold1'
  fold2 = SVG 'fold2' if document.getElementById 'fold2'
  update = (setUrl = true) ->
    cp = document.getElementById('cp').value
    return if cp == lastcp
    lastcp = cp
    url = document.location.pathname + '?cp=' + cp.replace(/ /g, '_')
    try
      history.pushState null, 'cp', url if setUrl
    catch SecurityError
      console.warn "Security prevents pushState: #{url}"
    font = decodeFont x: cp
    #console.log ':', cp, font
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
  document.getElementById('cp').addEventListener 'input', update
  loadState = ->
    if getParameterByName 'cp'
      document.getElementById('cp').value = getParameterByName 'cp'
        .replace /_/g, ' '
    else
      document.getElementById('cp').value = ''
    update false
  window.addEventListener 'popstate', loadState
  resize = ->
    gui = document.getElementById('gui')
    gui.style.height = Math.max(Math.floor(window.innerHeight - gui.getBoundingClientRect().top - 50), 100) + 'px'
  window.addEventListener 'resize', resize
  resize()
  loadState()

window?.onload = ->
  if document.getElementById 'cp'
    designer()
  else
    font = decodeFont fontEnc
    showUnfolded SVG('surface'), font[true]
    showFolded SVG('surface'), font[true]
    showUnfolded SVG('surface'), font[false]
    showFolded SVG('surface'), font[false]

window?.fontEnc = fontEnc
window?.showFolded = showFolded
window?.showUnfolded = showUnfolded
window?.parseEnc = parseEnc
window?.foldStrip = foldStrip
window?.getParameterByName = getParameterByName

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
