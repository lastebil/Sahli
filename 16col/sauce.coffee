class @ImageTextModeSAUCE

    parseUrl: ( url ) ->
        req = new XMLHttpRequest()
        req.open 'GET', url, false
        req.overrideMimeType 'text/plain; charset=x-user-defined'
        req.send null
        content = if req.status is 200 or req.status is 0 then req.responseText else ''
        @parse content

    parse: ( content ) ->
        sauceMarker = content.length - 128;
        return false if content.substr( sauceMarker, 5 ) isnt 'SAUCE'
        @id = 'SAUCE'
        @version = content.substr( sauceMarker + 5, 2 )
        @title = content.substr( sauceMarker + 7, 35 )
        @author = content.substr( sauceMarker + 42, 20 )
        @group = content.substr( sauceMarker + 62, 20 )
        @date = content.substr( sauceMarker + 82, 8 )
        @fileSize = @unpackLong content.substr( sauceMarker + 90, 4 )
        @dataType = @getByteAt content.substr( sauceMarker + 94, 1 )
        @fileType = @getByteAt content.substr( sauceMarker + 95, 1 )
        @tinfo1 = @unpackShort content.substr( sauceMarker + 96, 2 )
        @tinfo2 = @unpackShort content.substr( sauceMarker + 98, 2 )
        @tinfo3 = @unpackShort content.substr( sauceMarker + 100, 2 )
        @tinfo4 = @unpackShort content.substr( sauceMarker + 102, 2 )
        @commentCount = @getByteAt content.substr( sauceMarker + 104, 1 )
        @flags = @getByteAt content.substr( sauceMarker + 105, 1 )
        @filler = content.substr( sauceMarker + 106, 22 )

        commentMarker = sauceMarker - 5 - @commentCount * 64
        if @commentCount > 0 and content.substr( commentMarker, 5 ) is 'COMNT'
            commentMarker += 5
            @comments = []
            i = @commentCount
            while i-- > 0
                @comments.push content.substr( commentMarker, 64 )
                commentMarker += 64

        return true

    unpackLong: ( data ) ->
        lng = ((( @getByteAt( data, 3 ) << 8 ) + @getByteAt( data, 2 ) << 8 ) + @getByteAt( data, 1 ) << 8 ) + @getByteAt( data, 0 )
        if lng < 0
            lng += 4294967296
        return lng;

    unpackShort: ( data ) ->
        shrt = ( @getByteAt( data, 1 ) << 8 ) + @getByteAt( data, 0 )
        if shrt < 0
            shrt += 65536
        return shrt

    getByteAt: ( data, offset ) ->
        return data.charCodeAt( offset ) & 0xFF

