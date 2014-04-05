
class @ImageTextModeANSI extends @ImageTextMode
    constructor: ( options ) ->
        super @screen
        super @font
        @palette  = new ImageTextModePaletteANSI
        @tabstop  = 8
        @linewrap = 80
        @[k]  = v for own k, v of options

    ANSI_ESC        = String.fromCharCode(0x1b)
    ANSI_CSI        = ANSI_ESC + '['
    ANSI_TEXT_PROP  = 'm'
    ANSI_RESET      = '0'
    ANSI_FG         = '3'
    ANSI_BG         = '4'
    ANSI_FG_INTENSE = '9'
    ANSI_BG_INTENSE = '10'
    ANSI_CUR_DOWN   = 'B'
    ANSI_SEP        = ';'
    ANSI_RETURN     = 'A'

# not going to mess with this for now, as I think it is the 'write' code
# for the actual ansi editor. That would be bad to mess up.
# did redo the for loops to read nicer tho.

    write: ->
        content = "#{ ANSI_CSI }2J" # initiate document
        for y in [0...@screen.length]
            content += "\n" if !@screen[y]?
            continue if !@screen[y]?
            for x in [0...@getWidth()]
                pixel = @screen[y][x]
                if !pixel?
                    pixel = { ch: ' ', attr: 7   }
                attr = @gen_args(pixel.attr)
                if (attr != prevattr)
                    content += "#{ANSI_CSI}0;#{attr}#{ANSI_TEXT_PROP}"   
                    prevattr = attr
                content += if pixel.ch? then pixel.ch else ' '
                max_x = x
        content += "#{ ANSI_CSI }0m"
        @toBinaryArray(content)

    gen_args: ( attr ) ->
        fg      = 30 + ( attr & 7 )
        bg      = 40  + ( ( attr & 112 ) >> 4)
        bl      = if attr & 128 then 5 else ''
        intense = if attr & 8 then 1 else ''

# um why do we make this attrs variable and not use it?

        attrs = a for a in [fg, bg, bl, intense] when a != ''
        return [fg, bg, bl, intense].join(";")

    parse: ( content ) ->
        @screen = []
        @state = 0
        @x = 0
        @y = 0
        @save_x = 0
        @save_y = 0
        @attr = 7
        @argbuf = ''

        content = content.split( '' )
        while ch = content.shift()
            if @state is 0
                switch ch
                    when "\x1a" then @state = 3
                    when "\x1b" then @state = 1
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
                if ch isnt "["
                    @putpixel "\x1b" 
                    @putpixel "[" 
                    @state = 0
                else
                    @state = 2

            else if @state is 2
                if ch.match( '[A-Za-z]' )
                    args = ( parseInt( i ) for i in @argbuf.split ';' )

                    switch ch
                        when "m"
                            for arg in args
                                if arg is 0
                                    @attr = 7
                                else if arg is 1
                                    @attr |= 8
                                else if arg is 5
                                    @attr |= 128
                                else if 30 <= arg <= 37
                                    @attr &= 248
                                    @attr |= ( arg - 30 )
                                else if 40 <= arg <= 47 
                                    @attr &= 143
                                    @attr |= ( arg - 40 ) << 4

                        when "H", "f"
                            @y = ( args[ 0 ] or 1 ) - 1
                            @x = ( args[ 1 ] or 1 ) - 1
                            @y = 0 if @y < 0
                            @x = 0 if @x < 0
                        when "A"
                            @y -= args[ 0 ] or 1
                            @y = 0 if @y < 0
                        when "B"
                            @y += args[ 0 ] or 1
                        when "C"
                            @x += args[ 0 ] or 1
                        when "D"
                            @x -= args[ 0 ] or 1
                            @x = 0 if @x < 0
                        when "E"
                            @y += args[ 0 ] or 1
                            @x = 0
                        when "F"
                            @y -= args[ 0 ] or 1
                            @y = 0 if @y > 0
                            @x = 0
                        when "G"
                            @x = ( args[ 0 ] or 1 ) - 1
                        when "s"
                            @save_x = @x
                            @save_y = @y
                        when "u"
                            @x = @save_x
                            @y = @save_y
                        when "J"
                            if args.length is 0 or args[ 0 ] is 0
                                @screen[ i ] = null for i in [ @y + 1 .. screen.length - 1 ]
                                @screen[ @y ][ i ] = null for i in [ @x .. screen[ @y ].length - 1 ]
                            else if args[ 0 ] is 1
                                @screen[ i ] = null for i in [ 0 .. @y - 1 ]
                                @screen[ @y ][ i ] = null for i in [ 0 .. @x ]
                            else if args[ 0 ] is 2
                                @x = 0
                                @y = 0
                                @screen = []
                        when "K"
                            if args.length is 0 or args[ 0 ] is 0
                                @screen[ @y ][ i ] = null for i in [ @x .. @screen[ @y ].length - 1 ]
                            else if args[ 0 ] is 1
                                @screen[ @y ][ i ] = null for i in [ 0 .. @x ]
                            else if args[ 0 ] is 2
                                @screen[ @y ] = null

                    @argbuf = ''
                    @state = 0

                else
                    @argbuf += ch

            else if @state is 3
                break

            else
                @state = 0


    putpixel: ( ch ) ->
        @screen[ @y ] = [] if !@screen[ @y ]?
        @screen[ @y ][ @x ] = { ch: ch, attr: @attr }

        if ++@x >= @linewrap
            @x = 0
            @y++

