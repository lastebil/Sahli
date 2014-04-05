
class @ImageTextModeXBin extends @ImageTextMode

    # Header constants
    PALETTE          = 1
    FONT             = 2
    COMPRESSED       = 4
    NON_BLINK        = 8
    FIVETWELVE_CHARS = 16

    # Compression type constants
    NO_COMPRESSION        = 0
    CHARACTER_COMPRESSION = 64
    ATTRIBUTE_COMPRESSION = 128
    FULL_COMPRESSION      = 192

    # Compression byte constants
    COMPRESSION_TYPE    = 192
    COMPRESSION_COUNTER = 63

    constructor: ( options ) ->
        super
        @header = { width: 0, height: 0, fontisze: 0, flags: 0 }
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        @screen    = []
        headerData = content.substr( 0, 11 )
        if headerData.length isnt 11 || !headerData.match( '^XBIN\x1a' )
            throw new Error( 'File is not an XBin' )

        @header.width = @unpackShort( headerData.substr( 5, 2 ) )
        @header.height = @unpackShort( headerData.substr( 7, 2 ) )
        @header.fontsize = @getByteAt( headerData.substr( 9, 1 ) )
        @header.flags = @getByteAt( headerData.substr( 10, 1 ) )
        offset = 11

        if @header.flags & PALETTE
            @parsePaletteData( content.substr( offset, 48 ) );
            offset += 48

        if @header.flags & FONT
            fontlength = @header.fontsize
            if @header.flags & FIVETWELVE_CHARS
                fontlength *= 512
            else
                fontlength *= 256
            @parseFontData( content.substr( offset, fontlength ), @header.fontsize );
            offset += fontlength

        if @header.flags & COMPRESSED
            @_parse_compressed( content.substr( offset ) )
        else
            @_parse_uncompressed( content.substr( offset ) )

    _parse_compressed: ( data ) ->
        x = 0
        y = 0
        @screen[ y ] = []

        data = data.split( '' )
        while info = data.shift()
            info = @getByteAt( info, 0 )
            break if info == 26

            type = info & COMPRESSION_TYPE
            counter = ( info & COMPRESSION_COUNTER ) + 1

            ch = null
            attr = null

            while counter-- > 0
                switch type
                    when NO_COMPRESSION
                        ch   = data.shift()
                        attr = data.shift()
                    when CHARACTER_COMPRESSION
                        ch   = data.shift() if !ch?
                        attr = data.shift()
                    when ATTRIBUTE_COMPRESSION
                        attr = data.shift() if !attr?
                        ch   = data.shift()
                    else
                        ch   = data.shift() if !ch?
                        attr = data.shift() if !attr?

                @screen[ y ][ x ] = { ch: ch, attr: @getByteAt( attr, 0 ) }

                x++
                if x == @header.width
                    x = 0
                    y++
                    break if y == @header.height
                    @screen[ y ] = [] if !@screen[ y ]?

    _parse_uncompressed: ( data ) ->
        x = 0
        y = 0
        @screen[ y ] = []

        for i in [ 0 .. data.length - 2 ] by 2
            ch = data.substr( i, 1 )
            break if ch == "\x1a"
            attr = @getByteAt( data, i + 1 )
            @screen[ y ][ x ] = { 'ch': ch, 'attr': attr }
            x++
            if x == @header.width
                x = 0
                y++
                break if y == @header.height
                @screen[ y ] = [] if !@screen[ y ]?

    getWidth: ->
        return @header.width

    getHeight: ->
        return @header.height
