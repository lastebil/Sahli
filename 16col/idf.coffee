class @ImageTextModeIDF extends @ImageTextMode

    constructor: ( options ) ->
        super
        @header = { x0: 0, x1: 0, y0: 0, y1: 0 }
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        headerData = content.substr( 0, 12 )
        if headerData.length isnt 12 || !headerData.match( '^\x041.4' )
            throw new Error( 'File is not an IDF' )

        @header.x0 = @unpackShort( headerData.substr( 4, 2 ) )
        @header.y0 = @unpackShort( headerData.substr( 6, 2 ) )
        @header.x1 = @unpackShort( headerData.substr( 8, 2 ) )
        @header.y1 = @unpackShort( headerData.substr( 10, 2 ) )

        eodata = content.length - 48 - 4096

        if content.substr( content.length - 128, 5 ) == 'SAUCE'
            eodata -= 128

        @parseFontData( content.substr( eodata, 4096 ) )
        @parsePaletteData( content.substr( eodata + 4096, 48 ) )

        y = 0
        x = 0
        @screen[ y ] = []
        offset = 12

        while offset < eodata
            buffer  = content.substr( offset, 2 )
            info    = @unpackShort( buffer )
            offset += 2
            len     = 1

            if info == 1
                len     = @unpackShort( content.substr( offset, 2 ) ) & 255
                offset += 2
                buffer  = content.substr( offset, 2 )
                offset += 2

            ch   = buffer.substr( 0, 1 )
            attr = @getByteAt( buffer, 1 )

            for i in [ 1 .. len ]
                @screen[ y ][ x ] = { 'ch': ch, 'attr': attr }
                x++
                if x > @header.x1
                    x = 0
                    y++
                    @screen[ y ] = []

        @screen.pop() if @screen[ y ].length == 0

