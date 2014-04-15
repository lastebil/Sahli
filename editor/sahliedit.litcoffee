Sahli Editor
============

Editor for Sahli files.

- open existing file
- create new item
 * get filename from dir
 * insert SAUCE data if available
 * use SAUCE data to find font
 * allow Amiga choices
 * colorpicker
- edit existing item
- remove item
- clear whole file
- copy/clone
- move items around
- sort items
- output to screen (copy into file)
 * run from node - save filename dialog

== Create Initial crappage
We need to make a screen that has a few things in it for starters
Title, load existing, and new file options.

Silliness for checking that this works.

    $(-> $("h1").hide().slideDown(500))

Create buttos to choose between the New and Load functionalities
(As we aren't going to ever load a file _and_ do a new file.)
(If someone wants to do that, they can restart with F5 or something.)
Also hide the editor until needed, and initialize some elements.

    $(-> 
        $("#newsahli")
        .button { disabled: false}
        .click -> newsahli()
        )
                        
    $(->
        $("#loadsahli")
        .button { disabled: false}
        .click -> loadsahli()
        )
    $(->
        $(".hidden").hide()
        $("#amiga").button {icons: {primary:"ui-icon-gear"}}
            .click ->
                stuff = $(@).children()
                if @.value == "1"
                    stuff[1].textContent = 'Ansi'
                    @.value = "0"
                else
                    stuff[1].textContent = 'Ascii'
                    @.value = "1"
        $(".45box").css {width:'45%',float:'left'}
    )

The sahli file definition format is as follows:
"file" - the actual filename on disk, "name" - the title of the piece,
the boolean 'amiga' indicates if it is ansi or ascii (True = ascii),
width is the width (widest point of the file), author the author of the piece,
the color and bg items define the color for amiga ascii, and the font
defines the font similarly.  For PC ansi, this should be 'ansifont.'
The three remaining lines are informational and optional.

The slide format is currently unused, but consists of a background picture,
a html template, and a css file.

    class Sahli
        constructor: ->
            @emptyfiledef = {
                "file": "",
                "name": "",
                "amiga": true,
                "width": "",
                "author": "",
                "font": "Propaz",
                "color": [ 0,0,0,0 ],
                "bg": [ 0,0,0,0 ],
                "line1": "",
                "line2": "",
                "text": ""
            }
            @emptyslidesdef = {
                "background": "",
                "template": "",
                "css": ""
            }
            @empty = {
                "slides": @emptyslidesdef,
                "filedata": [ ]
            }

        loader: ->
            $.ajax {
                url: '../list.sahli',
                dataType: "json",
                success: (result) =>
                    @data = result
                    @.edit()
            }

Editor functionality:
Close the new/load buttons - unneeded now.
list, and allow dragon-droppings for sorting.  Doubleclick to edit, or use
edit button.

        edit: ->
            $('#buttonbox').hide()
            @buildlist @data

        buildlist: (data) ->
            $('#list').show 100
            $('#sortlist').append @.additem item for item in @data.filedata
            $('#sortlist').sortable().disableSelection()


        additem: (item) ->
            $("<li class='entry' id='#{item.file}'><span class='ui-icon ui-icon-arrowthick-2-n-s'></span>#{item.author} : #{item.name} : #{item.file}</li>")


        editline: (data) ->
            $("#formica").dialog {
                width:'800',
                modal: false,
                title:'Line Item', buttons: [{
                    text: "OK",
                    click: ->
                        $(@).dialog "close"
                }]
             }

A Helper function to dump json out of an object as text:

    dumpjson = (obj) ->
        JSON.stringify(obj)

When clicking 'New' we want to make a brand new Sahli, and then clear out
the buttons and create the editor bit as blank.

    newsahli = ->
        sahli = new Sahli
        sahli.data = sahli.empty
        sahli.data.filedata.push sahli.emptyfiledef
        sahli.edit()

And when clicking 'load' we want to load the existing sahli file.

    loadsahli = ->
        sahli = new Sahli
        sahli.loader 'list.sahli'
