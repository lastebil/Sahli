class @ImageTextModeADF extends @ImageTextMode

    COLOR_INDEX = [ 0, 1, 2, 3, 4, 5, 20, 7, 56, 57, 58, 59, 60, 61, 62, 63 ]

    constructor: ( options ) ->
        super
        @header = { version: 0 }
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        @header.version = @getByteAt( content, 0 )
        @parsePaletteData( content.substr( 1, 192 ) )
        @parseFontData( content.substr( 193, 4096 ) )

        x = 0
        y = 0
        @screen[ y ] = []

        for i in [ 4289 .. content.length - 2 ] by 2
            ch = content.substr( i, 1 )
            break if ch == "\x1a"
            attr = @getByteAt( content, i + 1 )
            @screen[ y ][ x ] = { 'ch': ch, 'attr': attr }
            x++
            if x == 80
                x = 0
                y++
                @screen[ y ] = []

        @screen.pop() if @screen[ y ].length == 0

    parsePaletteData: ( data ) ->
        colors = []
        for i in COLOR_INDEX
            j = i * 3
            r = @getByteAt( data, j )
            r = r << 2 | r >> 4
            g = @getByteAt( data, j + 1 )
            g = g << 2 | g >> 4
            b = @getByteAt( data, j + 2 )
            b = b << 2 | b >> 4
            colors.push [ r, g, b ]

        @palette = new ImageTextModePalette( { colors: colors } )
