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

exports = Sahli

Sahli = ->
  @outbox = $('div#outbox')
  @dbox = $('div#drawbox')
  @image = 0
  # scroll speed of 5 looks ... "ok" on macbook pro. 4 was original.
  @scroll_speed = 5
  @scroll_direction = 1
  @zoomspeed = 200
  @asciiasgfx = true
  @DEBUG = false
  @dbox.height document.height - 24
  @dbox.width document.width - 2
  @sizemult = 16
  # 32 is larger than screen, and somewhat silly
  @origheight = 0
  @origwidth = 0
  @filedata = ''
  @slides = 0
  @currentpic = 0
  @nonfsheight = document.height - 40

  @loadpic = (picdata, inserthere) ->
    switch picdata.filetype
      when 'plain'
        @loadplain picdata, inserthere
      when 'ansi'
        @loadhugeansi picdata, inserthere
      when 'bin'
        @loadansi picdata, inserthere
      when 'xbin'
        @loadansi picdata, inserthere
      when 'ice'
        @loadansi picdata, inserthere
      when 'avatar'
        @loadavatar picdata, inserthere
      when 'pcboard'
        @loadansi picdata, inserthere
      when 'idf'
        @loadansi picdata, inserthere
      when 'adf'
        @loadansi picdata, inserthere
      when 'tundra'
        @loadansi picdata, inserthere
      else
        @loadplain picdata, inserthere
    return

  @loadplain = (picdata, inserthere) ->
    pdiv = $('<div>')
    req = new XMLHttpRequest
    fname = @location + '/' + picdata.file
    ptxt = $('<pre></pre>')
    color = @calccolor(picdata.color)
    bgcolor = @calccolor(picdata.bg)
    pdiv.addClass 'scrolly'
    ptxt.addClass picdata.font.toLowerCase()
    ptxt.css
      'color': color
      'background-color': bgcolor
      'margin': 'auto'
    ptxt.width picdata.width * 8
    pdiv.width '100%'
    pdiv.append ptxt
    # this is going to be interesting when dealing with ansi files in UTF-8
    # or SHIFT-JIS etc  - is it needed now?
    req.overrideMimeType 'text/plain; charset=ISO-8859-1'

    req.onreadystatechange = ->
      if req.readyState == req.DONE
        if req.status == 200 or req.status == 0
          ptxt.text @responseText
          inserthere.after pdiv
        else
          @loaderror inserthere, fname, req.statusText, req.status
      return

    req.open 'GET', fname, true
    req.send null
    return

  @loadansi = (picdata, inserthere) ->
    fname = @location + '/' + picdata.file
    pdiv = $('<div>')
    AnsiLove.render fname, ((canv, SAUCE) ->
      pdiv.append canv
      inserthere.after pdiv
      @origwidth = canv.width
      @origheight = canv.height
      @SAUCE = SAUCE
      return
    ),
      'font': '80x25'
      'bits': '8'
      'columns': 160
      'thumbnail': 0
    return

  @loadhugeansi = (picdata, inserthere) ->
    fname = @location + '/' + picdata.file
    pdiv = $('<div>')
    calcheight = 0
    canvwidth = 0
    pdiv.css 'display', 'inline-block'
    AnsiLove.splitRender fname, ((chunks, SAUCE) ->
      chunks.forEach (canv) ->
        canv.style.verticalAlign = 'bottom'
        pdiv.append canv
        calcheight = calcheight + canv.height
        canvwidth = canv.width
        return
      inserthere.after pdiv
      @SAUCE = SAUCE
      @origwidth = canvwidth
      @origheight = calcheight
      pdiv.width canvwidth
      return
    ), 30, 'bits': '8'
    return

  @loadavatar = (picdata, inserthere) ->
    alert 'avatar', picdata, inserthere
    return

  @fillinfo = (picdata) ->
    infob = $('div.infobox')
    infob.find('h1').text picdata.name
    infob.find('h2').text picdata.author
    infob.find('h3#text').text picdata.line1
    infob.find('h3#text2').text picdata.line2
    infob.find('.bigtext').text picdata.text
    infob.find('span#filename').text picdata.file
    infob.find('span#infowidth').text '| ' + picdata.width + ' cols |'
    infob.find('span#fontname').text picdata.font
    return

  @loaderror = (inserthere, fname, errorText, errorCode) ->
    temptxt = ''
    if errorCode == 404
      temptxt = $('<h1>').text('Unable to find file ' + fname)
    else
      temptxt = $('<h1>').text('error! ' + errorText + ' code ' + errorCode +
       ' file ' + fname)
    inserthere.after temptxt
    return

  @calccolor = (colorset) ->
    'rgba(' + colorset.toString() + ')'

  @resize = (amt) ->
    canv = $('canvas')
    w = canv.width() * amt
    h = canv.height() * amt
    canv.animate {
      width: w
      height: h
    }, @zoomspeed
    return

  @fullwidth = ->
    @stopscroll()
    if $('canvas').width() == @dbox.width()
      @originalsize @zoomspeed
    else
      ratio = @origwidth / @dbox.width()
      $('canvas').animate {
        width: @dbox.width()
        height: @origheight / ratio
      }, @zoomspeed
    return

  @fullheight = ->
    canv = $('canvas')
    if canv.height() == @dbox.height()
      @originalsize @zoomspeed
    else
      ratio = @origheight / @dbox.height()
      canv.animate {
        height: @dbox.height()
        width: @origwidth / ratio
      }, @zoomspeed
    return

  @originalsize = (zoomspeed) ->
    # why do we not have origwidth now? hmm.
    canv = $('canvas')
    zs = zoomspeed
    # why are we not using this?
    zs = zs + 1
    canv.animate {
      width: @origwidth
      height: @origheight
    }, @zoomspeed
    return

  @toptext = (text) ->
    if @DEBUG
      $('h1#top').text text
    return

  @setscroll = ->
    bottom = $('.scrolly').height()
    scrollto = bottom
    steps = undefined
    # kill animations from before
    @dbox.stop true
    if @scroll_direction == 1
      @scroll_direction = -1
      steps = bottom - @dbox.scrollTop()
    else
      @scroll_direction = 1
      scrollto = 0
      steps = @dbox.scrollTop()
    @toptext @scroll_speed + ' | ' + steps
    @dbox.animate { scrollTop: scrollto }, @scroll_speed * steps, 'linear'
    return

  @resizedrawbox = (height) ->
    dbox1 = $('div#drawbox')
    if 'undefined' == height
      dbox1.height window.innerHeight - 2
    else
      dbox1.height height
    dbox1.width window.innerWidth - 2
    return

  @stopscroll = ->
    @dbox.stop true
    return

  @moveabout = (lines) ->
    line = @dbox.scrollTop()
    @dbox.stop true
    switch lines
      when 0
        @dbox.scrollTop 0
      when Infinity
        @dbox.scrollTop @origheight
      else
        @dbox.scrollTop line - lines * 8
        break
    return

  @requestsahlifile = (url) ->
    ref = this
    $.getJSON url, (json) ->
      ref.filedata = json.filedata
      ref.slides = json.slides
      ref.location = json.location
      ref.buildcompo()
      return
    return

  @buildcompo = ->
    @resizedrawbox()
    alert 'SAHLI READY TO GO'
    return

  @nextpic = ->
    @dbox.children().remove()
    # reset scrolling;
    @stopscroll()
    @scroll_direction = 1
    i = @currentpic
    filedata = @filedata
    filedata[i].pic = $('<h6>' + filedata[i].file + '</h6>')
    @dbox.append filedata[i].pic
    @loadpic filedata[i], filedata[i].pic
    @currentpic += 1
    if @currentpic > filedata.length - 1
      @currentpic = 0
    return

  @gofullscreen = ->
    docElm = document.documentElement
    window.setTimeout @resizedrawbox, 100
    if docElm.requestFullscreen
      docElm.requestFullscreen Element.ALLOW_KEYBOARD_INPUT
    else if docElm.mozRequestFullScreen
      docElm.mozRequestFullScreen Element.ALLOW_KEYBOARD_INPUT
    else if docElm.webkitRequestFullScreen
      docElm.webkitRequestFullScreen Element.ALLOW_KEYBOARD_INPUT
    return

  @cancelfullscreen = ->
    window.setTimeout @resizedrawbox, 100, @nonfsheight
    if document.exitFullscreen
      document.exitFullscreen()
    else if document.mozCancelFullScreen
      document.mozCancelFullScreen()
    else if document.webkitCancelFullScreen
      document.webkitCancelFullScreen()
    return

  @fixhelpbox = ->
    h = $('.help')
    xy =
      'top': 0
      'left': document.width / 2 - h.width() / 2
    h.css xy
    return

  @toggledebug = ->
    $('h1#top').fadeToggle()
    @DEBUG = !@DEBUG
    return

  @loadkeys = ->
    ref = this
    $(document).bind 'click', (ev) ->
      if ev.clientY < 100
        if ev.clientX < 100
          ref.nextpic()
        else
          ref.fullwidth()
      else
        ref.setscroll()
      return
    $(document).bind 'keydown', (ev) ->
      switch ev.which
        when 84
          # t
          ref.asciiasgfx = !ref.asciiasgfx
          ref.toptext ref.asciiasgfx
        # u
        when 85, 9
          # u
          $('div.infobox').slideToggle 'slow'
        when 70
          # f
          ref.gofullscreen()
        # esc
        when 27, 71
          # G, as escape seems to not get passed from fullscreen on chrome
          ref.cancelfullscreen()
        when 73
          # i
          ref.resize 2
        when 75
          # k
          ref.resize 0.5
        when 79
          # o
          ref.fullwidth()
        when 76
          # l
          ref.fullheight()
        when 80
          # p
          ref.originalsize 0
        when 83
          # s
          ref.setscroll()
        # h
        when 72, 191
          # "?" (also / but no shift)
          $('.help').fadeToggle 'fast'
        # +
        when 107, 190
          # .
          ref.scroll_speed = ref.scroll_speed * 2
          ref.toptext 'speed doubled:' + ref.scroll_speed
        # -
        when 109, 188
          # ,
          ref.scroll_speed = ref.scroll_speed / 2
          ref.toptext 'speed halved:' + ref.scroll_speed
        when 49
          # 1
          ref.scroll_speed = 1
        when 50
          #2
          ref.scroll_speed = 2
        when 51
          #3
          ref.scroll_speed = 3
        when 52
          #4
          ref.scroll_speed = 4
        when 53
          #5
          ref.scroll_speed = 5
        when 220
          # "\"
          ref.toptext ref.scroll_speed
        # backspace
        when 8, 68
          # D
          ref.stopscroll()
        # move about keys
        when 33
          # pgup
          ref.moveabout 24
        when 34
          # pgdwn
          ref.moveabout -24
        when 36
          # home
          ref.moveabout 0
        when 35
          # end
          ref.moveabout Infinity
        when 40
          # down
          ref.moveabout -1
        when 32
          # space
          ref.nextpic()
        when 38
          # up
          ref.moveabout 1
        # pause/break
        when 19, 121
          # F10
          ref.toggledebug()
        # debug alerts for these keys are annoying (:
        # f5
        when 116, 123
          # f12
        else
          if ref.DEBUG
            alert ev.which
          break
      return
    return

  @loadkeys()
  @fixhelpbox()
  ref = this
  $(window).resize ->
    ref.resizedrawbox()
    return
  debugger
  @requestsahlifile 'list.sahli'
  return
