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

    $(-> $("#newsahli").button { disabled: false} )
    $(-> $("#loadsahli").button { disabled: false} )


    