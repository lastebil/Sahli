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

Create a split button to choose between the New and Load functionalities
(As we aren't going to ever load a file _and_ do a new file.)
(If someone wants to do that, they can restart with F5 or something.)

    $(-> 
        $("#newsahli")
        .button { disabled: false}
        .click -> newsahli 'new'
        )
                        
    $(->
        $("#loadsahli")
        .button { disabled: false}
        .click -> alert "heyoh!"
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
        filedef = {
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
        slidesdef = {
            "background": "",
            "template": "",
            "css": ""
        }
        blank = {
            "slides": slidesdef,
            "filedef": [ filedef ]
        }

    dumpjson = (obj) ->
        JSON.stringify(obj)

    newsahli = ->
        sahli = new Sahli
        alert dumpjson this.sahli