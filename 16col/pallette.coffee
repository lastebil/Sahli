class @ImageTextModePalette

    constructor: ( options ) ->
        @colors = []
        @[k] = v for own k, v of options

    toRgbaString: ( color ) ->
        return 'rgba(' + color.join( ',' ) + ',1)';

# getting a "cannot call super outside an instance method" error here -
# the resulting code produced does not end up using the super/parent bit
# or at least it doesn't produce bugs in the result if it is not here.
# calling the constructor without super works, and with super the difference is
#  ImageTextModePaletteVGA.__super__.constructor.apply(this, arguments);
# is placed inside the constructor. I believe the end result, based on how
# this is used, is identical.
# I am not seeing this pattern (the 'super by itself') being used or referenced
# - instead I am seeting very different patterns using super to reference
# complete items. (referenced meaning "in books, searches, or coffescript
# documentation")

class @ImageTextModePaletteVGA extends @ImageTextModePalette
    constructor: (options) ->
        @colors = [
            [ 0x00, 0x00, 0x00 ],
            [ 0x00, 0x00, 0xaa ],
            [ 0x00, 0xaa, 0x00 ],
            [ 0x00, 0xaa, 0xaa ],
            [ 0xaa, 0x00, 0x00 ],
            [ 0xaa, 0x00, 0xaa ],
            [ 0xaa, 0x55, 0x00 ],
            [ 0xaa, 0xaa, 0xaa ],
            [ 0x55, 0x55, 0x55 ],
            [ 0x55, 0x55, 0xff ],
            [ 0x55, 0xff, 0x55 ],
            [ 0x55, 0xff, 0xff ],
            [ 0xff, 0x55, 0x55 ],
            [ 0xff, 0x55, 0xff ],
            [ 0xff, 0xff, 0x55 ],
            [ 0xff, 0xff, 0xff ]
        ]

class @ImageTextModePaletteANSI extends @ImageTextModePalette
    constructor: (options) ->
        @colors = [
            [ 0x00, 0x00, 0x00 ],
            [ 0xaa, 0x00, 0x00 ],
            [ 0x00, 0xaa, 0x00 ],
            [ 0xaa, 0x55, 0x00 ],
            [ 0x00, 0x00, 0xaa ],
            [ 0xaa, 0x00, 0xaa ],
            [ 0x00, 0xaa, 0xaa ],
            [ 0xaa, 0xaa, 0xaa ],
            [ 0x55, 0x55, 0x55 ],
            [ 0xff, 0x55, 0x55 ],
            [ 0x55, 0xff, 0x55 ],
            [ 0xff, 0xff, 0x55 ],
            [ 0x55, 0x55, 0xff ],
            [ 0xff, 0x55, 0xff ],
            [ 0x55, 0xff, 0xff ],
            [ 0xff, 0xff, 0xff ]
        ]