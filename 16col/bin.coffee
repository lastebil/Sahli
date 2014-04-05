class @ImageTextModeBin extends @ImageTextMode

    constructor: ( options ) ->
        super
        @linewrap = 160
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        x = 0
        y = 0
        @screen[ y ] = []

        for i in [ 0 .. content.length - 2 ] by 2
            ch = content.substr( i, 1 )
            break if ch == "\x1a"
            attr = @getByteAt( content, i + 1 )
            @screen[ y ][ x ] = { 'ch': ch, 'attr': attr }
            x++
            if x == @linewrap
                x = 0
                y++
                @screen[ y ] = []

        @screen.pop() if @screen[ y ].length == 0

