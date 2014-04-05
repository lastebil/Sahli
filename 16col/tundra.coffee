
class @ImageTextModeTundra extends @ImageTextMode

    constructor: ( options ) ->
        super
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        colors = [ [ 0, 0, 0 ] ]
        palidx = 1
        x  = 0
        y  = 0
        fg = 0
        bg = 0

        @screen[ y ] = []
        content = content.substr( 8 ).split( '' )
        while command = content.shift()
            break if command == "\x1a"
            command = command.charCodeAt( 0 )

            if command is 1
                y = @unpackLong( content.splice( 0, 4 ).join( '' ) )
                x = @unpackLong( content.splice( 0, 4 ).join( '' ) )
                @screen[ y ] = [] if !@screen[ y ]?
                continue

            ch = null

            if command is 2
                ch  = content.shift()
                rgb = @unpackLong( content.splice( 0, 4 ).join( '' ) )
                fg  = palidx++
                colors.push [
                    ( rgb >> 16 ) & 0x000000ff,
                    ( rgb >> 8 ) & 0x000000ff,
                     rgb & 0x000000ff
                ]
            else if command is 4
                ch  = content.shift()
                rgb = @unpackLong( content.splice( 0, 4 ).join( '' ) )
                bg  = palidx++
                colors.push [
                    ( rgb >> 16 ) & 0x000000ff,
                    ( rgb >> 8 ) & 0x000000ff,
                     rgb & 0x000000ff
                ]
            else if command is 6
                ch  = content.shift()
                fg  = palidx++
                bg  = palidx++
                for [ 0 .. 1 ]
                    rgb = @unpackLong( content.splice( 0, 4 ).join( '' ) )
                    colors.push [
                        ( rgb >> 16 ) & 0x000000ff,
                        ( rgb >> 8 ) & 0x000000ff,
                         rgb & 0x000000ff
                    ]

            ch = String.fromCharCode( command ) unless ch?

            @screen[ y ][ x ] = { 'ch': ch, 'fg': fg, 'bg': bg }
            x++
            if x == 80
                x = 0
                y++
                @screen[ y ] = []

        @screen.pop() if @screen[ y ].length == 0
        @palette = new ImageTextModePalette( { colors: colors } )
