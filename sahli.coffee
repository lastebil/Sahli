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
    $('body').css('cursor', 'none');
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
      when 'image'
        @loadpicture picdata, inserthere
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
# this is still needed for some Amiga stuff done on Amiga.
# probably should allow other overrides for UTF-8 and so on.
    req.overrideMimeType 'text/plain; charset=ISO-8859-1'
    req.onreadystatechange = ->
      if req.readyState == req.DONE
        if req.status == 200 or req.status == 0
          ptxt.text @responseText
          inserthere.after pdiv
          $('body').scrollTop 0
        else
          @loaderror inserthere, fname, req.statusText, req.status
    req.open 'GET', fname, true
    req.send null

  @loadpicture = (picdata, inserthere) ->
    fname = @location + '/' + picdata.file
    pdiv = $('<div>')
    pdiv.addClass 'scrolly'
    pdiv.addClass 'image'
    pdiv.width window.innerWidth
    pdiv.css 'display', 'inline-block'
    pimg = $('<img src="' + fname + '" />')
    pimg.addClass 'fullwidth'
    pdiv.append pimg
    inserthere.after pdiv
    $('h6').hide()
    $('body').scrollTop 0
    @origwidth = picdata.width
    @origheight = picdata.height
    @bestfit()

  @bestfit = =>
    if $('div.scrolly').hasClass('image')
      if $('div.scrolly').hasClass('bestfitMode')
        $('div.scrolly').removeClass 'bestfitMode'
        $('div.scrolly').addClass 'fullwidthMode'
        $('div.scrolly').width window.innerWidth
        $('div.scrolly').height("")
        $('img.bestfit').addClass 'fullwidth'
        $('img.bestfit').removeClass 'bestfit'
      else
        $('h6').hide()
        $('div.scrolly').addClass 'bestfitMode'
        $('div.scrolly').removeClass 'fullwidthMode'
        $('div.scrolly').width window.innerWidth
        $('div.scrolly').height window.innerHeight
        $('img.fullwidth').addClass 'bestfit'
        $('img.fullwidth').removeClass 'fullwidth'

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
      $('body').scrollTop 0
      @SAUCE = SAUCE
      @origwidth = canvwidth
      @origheight = calcheight
      pdiv.width canvwidth
    ), 30, {'bits': '8', "font": picdata.font}

  @loadavatar = (picdata, inserthere) ->
    console.log 'avatar', picdata, inserthere

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
      alert "SAHLI READY TO GO\n#{@filedata.length} Entries\nH for Help\nSpace to Start"

  @loadinfopanel = (index) ->
    data = @filedata[index]
    $('.infobox h1').text  data.name
    $('.infobox h2').text  data.author
    $('h3.infobox')[0].textContent = data.line1
    $('h3.infobox')[1].textContent = data.line2
    $('p.bigtext').text data.text
    $('.infobox span')[0].textContent = data.filename
    $('.infobox span')[1].textContent = data.width
    $('.infobox span')[2].textContent = data.font

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
    $('h6').show()
    @loadpic filedata[i], filedata[i].pic
    @currentpic += 1
    if @currentpic > filedata.length - 1
      @currentpic = 0
    $('#panel').hide()
    $('#outbox').show()
    $('body').stop()
    @loadinfopanel i

  @prevpic = =>
    i = @currentpic-2
    if i < 0
      i = i + @filedata.length
    @currentpic = i
    @nextpic()

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

# chromium wasn't working with up/down/pageup/pagedown, firefox was. This makes
# both work the same way.

  @moveline = (direction) ->
    curpos = $('body').scrollTop()
    $('body').scrollTop(curpos + (16*direction))

  @changescrolldirection = (direction) ->
    @scroll_direction = direction
    $('body').stop()
    @setscroll()

#    - save width upon draw
#    - toggle zoom out to full width / normal
#    - with a number, change width by that much
# if scrolling, where are we in the doc? zoom to THAT area. - not implemented
  @zoom = (amt) ->
    zoomee = $('div.scrolly')
    if amt?
      if amt == 0
        newwidth = @origwidth
      else
        newwidth = zoomee.width() + amt
      zoomee.width newwidth
      $('canvas').width newwidth
    else
      if parseInt( zoomee.width(), 10 ) != parseInt( @origwidth, 10)
        zoomee.width @origwidth
        $('canvas').width '100%'
      else
        zoomee.width '100%'
        $('canvas').width '100%'

# create a panel of 'strips' so as to show a very long vertical piece on one
# big 'plate'

  @panelmode = ->
    $('#panel').toggle()
    canvs = $('canvas')
    $('.scrolly').width @origwidth
    if $('#panel').css('display') != 'none'
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
    else
      $('#outbox').show()
      $('.scrolly').append pic for pic in canvs
      canvs.width @origwidth
      $('body').scrollTop 0

  @createpanel = (i,amt) ->
    dcol = $("<div id='column#{i}' class='panelcolumn'>#{i}</div>")
    dcol.width amt

  @loadkeys = ->

    $(document).on('click', (ev) =>
      clickx = ev.clientX
      clicky = ev.clientY
      wh = window.innerHeight
      ww = window.innerWidth
      if clicky > wh-100
        @nextpic()
      if clicky < 100
        @setscroll()
      if (clicky > 100 && clicky < wh-100 )
        if clickx < 100
          @togglefullscreen()
        if clickx > ww-100
          @panelmode()
      )
    $(document).on('keydown', (ev) =>
      switch ev.which
        when @keycode ' '
          @nextpic()
        when @keycode 'p'
          @prevpic()
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
        when @keycode 'q'
          @bestfit()
        when @keycode 'w'
          @changescrolldirection -1
        when @keycode 'x'
          @changescrolldirection 1
        when @keycode 'c'
          @panelmode()
        when @keycode 'i'
          $('div.infobox').toggle()
        when @keycode 'v'
          $('h6').show()
          $('h6').height( (window.innerHeight - $('.scrolly').height()) / 2 )
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
        when 40 # down
          @moveline 1
        when 38 # up
          @moveline -1
        when 34 # pagedown
          @moveline 40
        when 33 # pageup
          @moveline -40
        when @keycode 'h'
          $('.help').css {'left':'33%'}
          $('.help').toggle 'fast'
        else
          console.log ev.which
      )
