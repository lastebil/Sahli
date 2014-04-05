
class @ImageTextModePCBoard extends @ImageTextMode

    constructor: ( options ) ->
        super
        @tabstop  = 8
        @linewrap = 80
        @codes    = { POFF: '', WAIT: '' }
        this[k]  = v for own k, v of options

    parse: ( content ) ->
        @screen = []
        @state = 0
        @x = 0
        @y = 0
        @attr = 7

        for key, val of @codes
            code = new RegExp '@' + key + '@', 'g'
            content.replace code, val

        content = content.split( '' )
        while ch = content.shift()
            if @state is 0
                switch ch
                    when "\x1a" then @state = 2
                    when '@' then @state = 1
                    when "\n"
                        @x = 0
                        @y++
                    when "\r" then break
                    when "\t"
                        i = ( @x + 1 ) % @tabstop
                        @putpixel ' ' while i-- > 0
                    else
                        @putpixel ch
            else if @state is 1
                if ch is 'X'
                    @attr = ( parseInt( content.shift(), 16 ) << 4 ) + parseInt( content.shift(), 16 )
                else if ch + content[ 0..2 ].join( '' ) is 'CLS@'
                    content.shift() for [ 1 .. 3 ]
                    @screen = []
                else if ch + content[ 0..2 ].join( '' ) is 'POS:'
                    content.shift() for [ 1 .. 3 ]
                    @x = content.shift()
                    @x += content.shift() if content[ 0 ] isnt '@'
                    @x--

                    content.shift()
                else
                    @putpixel '@'
                    @putpixel ch

                @state = 0
            else if @state is 2
                break
            else
                @state = 0

    putpixel: ( ch ) ->
        @screen[ @y ] = [] if !@screen[ @y ]?
        @screen[ @y ][ @x ] = { ch: ch, attr: @attr }

        if ++@x >= @linewrap
            @x = 0
            @y++

