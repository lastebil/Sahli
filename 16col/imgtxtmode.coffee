class @ImageTextMode

    @VERSION = '0.01'

    constructor: ( options ) ->
        @screen  = []
        @palette = new ImageTextModePaletteVGA()
        @font    = new ImageTextModeFont8x16()
        @[k]  = v for own k, v of options

    parseUrl: ( url ) ->
        req = new XMLHttpRequest()
        req.open 'GET', url, false
        req.overrideMimeType 'text/plain; charset=x-user-defined'
        req.send null
        content = if req.status is 200 or req.status is 0 then req.responseText else ''
        @parse content

    unpackShort: ( data ) ->
        shrt = ( @getByteAt( data, 1 ) << 8 ) + @getByteAt( data, 0 )
        if shrt < 0
            shrt += 65536
        shrt

    unpackLong: ( data ) ->
        lng = ((( @getByteAt( data, 0 ) << 8 ) + @getByteAt( data, 1 ) << 8 ) + @getByteAt( data, 2 ) << 8 ) + @getByteAt( data, 3 )
        if lng < 0
            lng += 4294967296
        lng

    getByteAt: ( data, offset ) ->
        data.charCodeAt( offset ) & 0xFF

# could we replace this with math.max ?  Not worth it,called once per view
# we COULD, but we'd do some crap like "Math.max.apply(null,blah) and that's not readable"
    getWidth: ->
        max = 0
        for y in [ 0 .. @screen.length - 1 ]
            max = @screen[ y ].length if @screen[ y ]? && @screen[ y ].length > max
        max

    getHeight: ->
        @screen.length

    parsePaletteData: ( data ) ->
        colors = []
        for i in [ 0 .. 45 ] by 3
            r = @getByteAt( data, i )
            r = r << 2 | r >> 4
            g = @getByteAt( data, i + 1 )
            g = g << 2 | g >> 4
            b = @getByteAt( data, i + 2 )
            b = b << 2 | b >> 4
            colors.push [ r, g, b ]

        @palette = new ImageTextModePalette( colors: colors )

    parseFontData: ( data, height = 16 ) ->
        chars = []
        for i in [ 0 ... data.length / height ]
            chr = []
            for j in [ 0 ... height ]
                chr.push @getByteAt( data, i * height + j )
            chars.push chr
        @font = new ImageTextModeFont( { chars: chars, height: height } )

# the majority of time is spent in this routine
# list comprehension seems to speed up from 1.8 seconds to 1.29 seconds from first comprehension / cleanup?

    renderCanvas: ( canvasElem ) ->
        w = @getWidth() * @font.width
        h = @getHeight() * @font.height

        canvas = document.createElement 'canvas'
        canvas.setAttribute 'width', w
        canvas.setAttribute 'height', h
        ctx = canvas.getContext '2d'

        for cy in [ 0 ... @screen.length ]
            if @screen[ cy ]?
                for cx in [ 0 ... @screen[ cy ].length ]
                    pixel = @screen[ cy ][ cx ]
                    curfillstyle = null
                    if pixel?
                        if pixel.attr?
                            fg = pixel.attr & 15
                            bg = ( pixel.attr & 240 ) >> 4
                        else
                            fg = pixel.fg
                            bg = pixel.bg

                        px = cx * @font.width
                        py = cy * @font.height

                        ctx.fillStyle = @palette.toRgbaString( @palette.colors[ bg ] )
                        ctx.fillRect px, py, @font.width, @font.height

                        ctx.fillStyle = @palette.toRgbaString( @palette.colors[ fg ] )
                        chr = @font.chars[ pixel.ch.charCodeAt( 0 ) & 0xff ]
                        i = 0
                        for line in chr
                            ctx.fillRect px + j, py + i, 1, 1 for j in [ 0 ... @font.width ] when line & (1 << @font.width - 1 - j )
                            i += 1

        canvasElem.setAttribute 'width', w
        canvasElem.setAttribute 'height', h
        ctx = canvasElem.getContext '2d'
        ctx.drawImage canvas, 0, 0

    toBinaryArray: (str) ->
        buf = new ArrayBuffer(str.length * 2) # 2 bytes for each char
        bufView = new Uint8Array(buf)
        bufView[i] = str.charCodeAt(i) for i in [0...str.length]
        buf

