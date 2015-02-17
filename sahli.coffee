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


  @resizedrawbox = (height) ->
    dbox1 = $('div#drawbox')
    if 'undefined' == height
      dbox1.height window.innerHeight - 2
    else
      dbox1.height height
    dbox1.width window.innerWidth - 2


  @requestsahlifile = (url) ->
    ref = this
    $.getJSON url, (json) ->
      ref.filedata = json.filedata
      ref.slides = json.slides
      ref.location = json.location
      ref.buildcompo()

  @buildcompo = ->
#    @resizedrawbox()
    alert 'SAHLI READY TO GO'

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

  @toggledebug = ->
    $('h1#top').fadeToggle()
    @DEBUG = !@DEBUG
    return
  