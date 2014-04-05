class @ImageTextModeAVATAR extends @ImageTextMode

    constructor: ( options ) ->
        super
        @tabstop  = 8
        @linewrap = 80
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        @screen = []
        @x = 0
        @y = 0
        @attr = 3

        content = content.split( '' )
        while ch = content.shift()
            if ch is "\x1a"
                break
            else if ch is "\n"
                @x = 0
                @y++
            else if ch is "\r"
                continue
            else if ch is "\t"
                i = ( @x + 1 ) % @tabstop
                @putpixel ' ' while i-- > 0
            else if ch.charCodeAt( 0 ) is 12
                @screen = []
                @attr = 3
                @insert = false
            else if ch.charCodeAt( 0 ) is 25
                ch = content.shift()
                i  = content.shift().charCodeAt( 0 )
                @putpixel( ch ) while i-- > 0
            else if ch.charCodeAt( 0 ) is 22
                c = content.shift().charCodeAt( 0 )
                switch c
                    when 1
                        @attr = content.shift().charCodeAt( 0 ) & 0x7f
                    when 2
                        @attr |= 0x80
                    when 3
                        @y--
                        @y = 0 if @y < 0
                    when 4
                        @y++
                    when 5
                        @x--
                        @x = 0 if @x < 0
                    when 6
                        @x++
                    when 7
                        @screen[ @y ][ i ] = null for i in [ @x .. screen[ @y ].length - 1 ]
                    when 8
                        @y = content.shift().charCodeAt( 0 ) - 1
                        @x = content.shift().charCodeAt( 0 ) - 1
                        @y = 0 if @y < 0
                        @x = 0 if @x < 0
            else
                @putpixel ch

    putpixel: ( ch ) ->
        @screen[ @y ] = [] if !@screen[ @y ]?
        @screen[ @y ][ @x ] = { ch: ch, attr: @attr }

        if ++@x >= @linewrap
            @x = 0
            @y++
