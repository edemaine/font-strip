window?.onload = ->
  lastcp = null
  unfold1 = SVG().addTo '#unfold1'
  unfold2 = SVG().addTo '#unfold2' if document.getElementById 'unfold2'
  fold1 = SVG().addTo '#fold1'
  fold2 = SVG().addTo '#fold2' if document.getElementById 'fold2'
  update = (setUrl = true) ->
    cp = document.getElementById('cp').value
    opacity = document.getElementById('opacity')?.value ? '50'
    if setUrl
      url = "#{document.location.pathname}?cp=#{cp.replace /[ ]/g, '_'}"
      url += "&opacity=#{opacity}" unless opacity == '50'
      url += '&backlight=1' if document.getElementById('backlight')?.checked
      if cp != lastcp
        history.pushState null, 'cp', url
      else
        history.replaceState null, 'style', url
    return updateStyle() if cp == lastcp
    lastcp = cp
    font = decodeFont x: cp
    document.getElementById('aspectRatioWith')?.innerHTML = font.true.x.width / font.true.x.height
    document.getElementById('aspectRatioWithout')?.innerHTML = font.false.x.width / font.false.x.height
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
    updateStyle()
  updateStyle = -> updateStyles [unfold1, unfold2, fold1, fold2]
  document.getElementById('backlight')?.addEventListener 'input', update
  document.getElementById('opacity')?.addEventListener 'input', update
  document.getElementById('cp').addEventListener 'input', update
  loadState = ->
    if getParameterByName 'cp'
      document.getElementById('cp').value = getParameterByName 'cp'
        .replace /_/g, ' '
    else
      document.getElementById('cp').value = ''
    document.getElementById('opacity')?.value = parseInt getParameterByName('opacity') ? 50
    document.getElementById('backlight')?.checked = getParameterByName 'backlight'
    update false
  window.addEventListener 'popstate', loadState
  resize = ->
    gui = document.getElementById('gui')
    gui.style.height = Math.max(Math.floor(window.innerHeight - gui.getBoundingClientRect().top - 50), 100) + 'px'
  window.addEventListener 'resize', resize
  resize()
  loadState()

  document.getElementById('downloadCP')?.addEventListener 'click', ->
    download cleanupSVG(unfold1.svg()), 'strip-unfolded.svg'
  document.getElementById('downloadFolded')?.addEventListener 'click', ->
    download cleanupSVG(fold1.svg()), 'strip-folded.svg'
  document.getElementById('downloadSim')?.addEventListener 'click', ->
    download simulateSVG(unfold1), 'strip-simulate.svg'
  document.getElementById('simulate')?.addEventListener 'click', ->
    simulate simulateSVG unfold1
