###
  .___________________________________,       ___
  |            /      |   |      .     \    .(___):
  |        _______    |          :      \   :     |
: |___/      /        |          |       \__|     |
|           /         |          |          |     |
l__________/__________|___|______l__________j_____j

     Ansi/Ansi Viewer in Ecmascript
 Coded by Sir Garbagetruck / Accession 2013
 Uses fonts by DMG, http://trueschool.se
 Uses Andy Herbert's Ansilove.js for rendering.
###

class @Sahli
  constructor: () ->
    # I don't think we actually are going to have one, as we don't
    # need instance variables (things used outside the function)

  @loadpic = (picdata, inserthere) ->
    switch picdata.filetype
      when 'plain'
        @loadplain picdata, inserthere
      when 'ansi'
        @loadhugeansi picdata, inserthere
      when 'bin'
        @loadhugeansi picdata, inserthere
      when 'xbin'
        @loadhugeansi picdata, inserthere
      when 'ice'
        @loadhugeansi picdata, inserthere
      when 'avatar'
        @loadavatar picdata, inserthere
      when 'pcboard'
        @loadhugeansi picdata, inserthere
      when 'idf'
        @loadhugeansi picdata, inserthere
      when 'adf'
        @loadhugeansi picdata, inserthere
      when 'tundra'
        @loadhugeansi picdata, inserthere
      else
        @loadplain picdata, inserthere

  @loadplain = (picdata, inserthere) ->
    pdiv = $('<div>')
    req = new XMLHttpRequest
    fname = @location + '/' + picdata.file
    buf = $('<span>')
    buf.css {'margin':'0 auto'}
    ptxt = $('<pre>')
    color = @calccolor(picdata.color)
    bgcolor = @calccolor(picdata.bg)
    pdiv.addClass 'scrolly'
    ptxt.addClass picdata.font.toLowerCase()
    ptxt.css
      'color': color
      'background-color': bgcolor
      'margin': 'auto'
      'display': 'inline-block'
    ptxt.width picdata.width * 8
    @origwidth = ptxt.width
    pdiv.width ptxt.width
    pdiv.prepend buf.clone()
    pdiv.append ptxt
    pdiv.append buf
    # this is going to be interesting when dealing with ansi files in UTF-8
    # or SHIFT-JIS etc  - is it needed now?
    req.overrideMimeType 'text/plain; charset=ISO-8859-1'
    req.onreadystatechange = ->
      if req.readyState == req.DONE
        if req.status == 200 or req.status == 0
          ptxt.text @responseText
          inserthere.after pdiv
          $('body').scrollTop(0)
        else
          @loaderror inserthere, fname, req.statusText, req.status
    req.open 'GET', fname, true
    req.send null

  @loadansi = (picdata, inserthere) ->
    fname = @location + '/' + picdata.file
    pdiv = $('<div>')
    pdiv.addClass 'scrolly'
    AnsiLove.render fname, ((canv, SAUCE) ->
      pdiv.append canv
      inserthere.after pdiv
      @origwidth = canv.width
      @origheight = canv.height
      @SAUCE = SAUCE
    ),
      'font': '80x25'
      'bits': '8'
      'columns': 160
      'thumbnail': 0

  @loadhugeansi = (picdata, inserthere) ->
    fname = @location + '/' + picdata.file
    pdiv = $('<div>')
    calcheight = 0
    canvwidth = 0
    pdiv.css 'display', 'inline-block'
    pdiv.addClass 'scrolly'
    AnsiLove.splitRender fname, ((chunks, SAUCE) =>
      chunks.forEach (canv) ->
        canv.style.verticalAlign = 'bottom'
        pdiv.append canv
        calcheight = calcheight + canv.height
        canvwidth = canv.width
      inserthere.after pdiv
      @SAUCE = SAUCE
      @origwidth = canvwidth
      @origheight = calcheight
      pdiv.width canvwidth
    ), 30, 'bits': '8'

  @loadavatar = (picdata, inserthere) ->
    alert 'avatar', picdata, inserthere

  @requestsahlifile = (url) ->
    @loadkeys()
    @DEBUG = false
    @fullscreen = false
    @scroll_speed= 5
    @scroll_direction= 1
    @asciiasgfx= false
    @currentpic= 0
    $.getJSON url, (json) =>
      @filedata = json.filedata
      @slides = json.slides
      @location = json.location

      alert "SAHLI READY TO GO\n#{@filedata.length} Entries"

  @nextpic = =>
    viewbox = $('div#sahliviewer')
    viewbox.children().remove()
    $('#panel').empty()
    @scroll_direction = 1
    @scroll_speed = 5
    i = @currentpic
    filedata = @filedata
    filedata[i].pic = $('<h6>' + filedata[i].file + '</h6>')
    viewbox.append filedata[i].pic
    @loadpic filedata[i], filedata[i].pic
    @currentpic += 1
    if @currentpic > filedata.length - 1
      @currentpic = 0
    $('#panel').hide()
    $('#outbox').show()
    $('body').stop()
    $('body').scrollTop(0)


  @togglefullscreen = ->
    docElm = document.documentElement
    if @fullscreen
      if document.exitFullscreen
        document.exitFullscreen()
      else if document.mozCancelFullScreen
        document.mozCancelFullScreen()
      else if document.webkitCancelFullScreen
        document.webkitCancelFullScreen()
      @fullscreen = false
    else
      if docElm.requestFullscreen
        docElm.requestFullscreen Element.ALLOW_KEYBOARD_INPUT
      else if docElm.mozRequestFullScreen
        docElm.mozRequestFullScreen Element.ALLOW_KEYBOARD_INPUT
      else if docElm.webkitRequestFullScreen
        docElm.webkitRequestFullScreen Element.ALLOW_KEYBOARD_INPUT
      @fullscreen = true

  @toggledebug = ->
    $('h1#top').fadeToggle()
    @DEBUG = !@DEBUG

  @keycode = (char) ->
    char.toUpperCase().charCodeAt 0

  @calccolor = (colorset) ->
    "rgba(#{colorset.toString()})"

  @loaderror = (inserthere, fname, errortext, errorcode) ->
    if errorcode == 404
      errstr = "Unable to find #{fname}"
    else
      errstr = "error! #{errortext} / code #{errorcode}"
    inserthere.after $("<h1>").text("#{errstr}")

  @setscroll = ->
    scrollbox = $('body')
    bottom = $('body').height()
    scrollto = bottom
    # kill animations from before
    scrollbox.stop true
    if @scroll_direction == 1
      @scroll_direction = -1
      steps = bottom - scrollbox.scrollTop()
    else
      @scroll_direction = 1
      scrollto = 0
      steps = scrollbox.scrollTop()
    console.log "#{@scroll_speed} | #{steps}"
    scrollbox.animate { scrollTop: scrollto }, @scroll_speed * steps, 'linear'

  @changespeed = (speed) ->
    @scroll_speed = speed
    $('body').stop()
    @scroll_direction = - @scroll_direction
    @setscroll()

  @changescrolldirection = (direction) ->
    @scroll_direction = direction
    $('body').stop()
    @setscroll()

#    - save width upon draw
#    - toggle zoom out to full width / normal
#    - with a number, change width by that much
# if scrolling, where are we in the doc? zoom to THAT area.
  @zoom = (amt) ->
    zoomee = $('div.scrolly')
    if amt?
      if amt == 0
        newwidth = @origwidth
      else
        newwidth = zoomee.width() + amt
      console.log "#{zoomee.width()} #{newwidth}"
      zoomee.width newwidth
      $('canvas').width newwidth
    else
      if zoomee.width() != @origwidth
        zoomee.width @origwidthg
        $('canvas').width '100%'
      else
        zoomee.width '100%'
        $('canvas').width '100%'

# calculate # strips - how many times does window height go into full height
# and then move the canvases into it. - done
# outbox toggled last to avoid losing width. (prolly need to fix.)
  @panelmode = ->
    $('#panel').toggle()
    canvs = $('canvas')
    if $('.scrolly').width() == @origwidth
      $('.scrolly').width '100%'
      $('#panel').empty()
      ww = window.innerWidth
      wh = window.innerHeight
      numpanels = canvs.length
      screenratio = ww/wh

      panelratio = canvs[0].height/canvs[0].width

      x = Math.sqrt numpanels/screenratio
      numcols = Math.round(screenratio*x)
      picdpercol = Math.round(numpanels/numcols)

      newwidth = ww/numcols

      canvs.width newwidth

      newheight = canvs.height()
      panelsperslot = Math.floor wh/newheight
      panelslotheight = panelsperslot * newheight

      outer = $('<div>')
      console.log numcols
#      outer.append @createpanel(i,newwidth - 6) for i in [1..numcols-1]
      outer.addClass 'nosb'
      $('#panel').append outer
      $('#outbox').toggle()

      level = 0
      drawcol = 1
      ct = 0
      outer.append @createpanel(1,newwidth - 6)
      for pic in canvs
        $("#column#{drawcol}").append pic
        level += 1
        ct += 1
        if level == panelsperslot
          level = 0
          drawcol = drawcol + 1
          if ct < numpanels
            outer.append @createpanel(drawcol,newwidth - 6)

      console.log "ww: #{ww} wh: #{wh} numpanels: #{numpanels} x: #{x}"
      console.log "numcols: #{numcols} picdpercol: #{picdpercol}"
      console.log "psh: #{panelslotheight} pps: #{panelsperslot}"
      console.log "a*b: #{panelsperslot*(numcols-1)}"

    else
      $('.scrolly').width @origwidth
      $('#outbox').show()
      $('.scrolly').append pic for pic in canvs
      canvs.width @origwidth
      $('body').scrollTop 0


  @createpanel = (i,amt) ->
    dcol = $("<div id='column#{i}'>#{i}</div>")
    dcol.addClass 'panelcolumn'
    dcol.width amt

  @loadkeys = ->
    $(document).on('keydown', (ev) =>
      switch ev.which
        when @keycode ' '
          @nextpic()
        when @keycode 'f'
          @togglefullscreen()
        when @keycode 's'
          @setscroll()
        when @keycode 't'
          $('body').scrollTop 0
          @zoom 0
        when @keycode 'b'
          $('body').scrollTop $('body').height()
        when @keycode 'a'
          $('body').stop()
          @scroll_direction = - @scroll_direction
        when @keycode 'z'
          @zoom()
        when @keycode 'e'
          @zoom 100
        when @keycode 'r'
          @zoom -100
        when @keycode 'w'
          @changescrolldirection -1
        when @keycode 'x'
          @changescrolldirection 1
        when @keycode 'c'
          @panelmode(1)
        when @keycode '1'
          @changespeed 1
        when @keycode '2'
          @changespeed 2
          @scroll_speed = 2
        when @keycode '3'
          @changespeed 3
          @scroll_speed = 3
        when @keycode '4'
          @changespeed 4
          @scroll_speed = 4
        when @keycode '5'
          @changespeed 5
        when @keycode 'h'
          $('.help').css {'left':'33%'}
          $('.help').toggle 'fast'
        else
          console.log ev.which
      )
