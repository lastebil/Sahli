      .___________________________________.     ._____.
      |            /      |   |      .    |     |_____|
      |           ____    |          :    |     |     |
    : |___/      /        |          |    l_____|     |
    |           /         |          |          |     |
    l__________/__________|___|______l__________j_____j

               Ansi/Ansi Viewer in Ecmascript
        Coded by Sir Garbagetruck / Accession 2013
          Uses fonts by DMG, http:trueschool.se
     Uses SixteenColors textmode js library for rendering
--
This ANSI / Ascii viewer was designed _SPECIFICALLY_ to
address shortcomings with acidview and other viewers in
running ANSI/Ascii compos.  I've run the Breakpoint and
Revision Ansi/Ascii compo for... um, I dunno how long.
A while. Well there hasn't been a Breakpoint since 2010
and I did unofficial compos there for a few years.  The
first time I ran it, Acid View puked on me, and I heard
a bunch of crap from people - because admittedly, when
you submit something, you don't expect the viewer to
flake out on you and make it so your entry only is on
the screen for 5 seconds.  In additional years it just
got WORSE.  I used 'a3b' to run the compo at Outline
one year, and that worked fine - BUT most of the time
the compo machine is running some crap OS that isn't
Amiga and isn't Unix-like, so... PLUS the beam system
(in the US 'beam system' would be 'projector' (:  )
at most demoparties these days is set to do full HD...
so if we just would do something in a browser, it would
all work out nicely.

That was the impetus for this, and it's turned out...
well, fairly well.  It has been used at Revision 2013
and Evoke 2013, and the folks who saw their stuff in
it have basically said it is really good.  I think it
needs a bit more feedback and some bugfixes, and the
folks at sixteencolors have had some suggestions and
then there's the "this could be included in ANSI packs"
idea...

* To run this you should use a modern browser.
* "Modern" means "not IE."
* someone _else_ might add stuff to make it work on IE.
* I will _NOT_ incorporate that into this code.
* Android tablets ARE considered modern; Ipad/Iphone too.
* I haven't tested on MorphOS yet.

To use with _local_ files you need to run your browser
in "developer" mode, that means:

   *** DO NOT OPEN ANY LINKS ON THE INTERNET ***
   
This works just fine if you use remote urls for the files.

  *** DO NOT. EVER. MIX REMOTE AND LOCAL FILES
      WHEN USING THIS VIEWER. OR, FOR THAT MATTER,
      RUNNING JAVASCRIPT DEMOS THAT USE DEVELOPER /
      LOWER SECURITY MODE. PERIOD. THIS WARNING
      APPLIES TO YOU AND YOUR ENTIRE FAMILY AND
      EVERY PERSON ALIVE, DEAD, OR IMAGINARY,
      INCLUDING THE NONEXISTENT.               ***
      
This product is licensed under the WTFPL.  See:
             http://www.wtfpl.net
for details, or just get the license:
        http://www.wtfpl.net/txt/copying/

 * tl;dr wtf omg how duz thz wrk omg wtf
 
1. Place the important files (.js, .css, .html, .sahli) on a webserver or local directory.
2. Put your ansi and ascii files on the webserver / local directory.
3. Edit the 'list.sahli' file (it's json) to have
  the proper filenames.
  * yes an editor is coming for the standalone
  * for the integrated-with-partymeister version,
  partymeister will do the sorting/listgen and you
  will take the generated 'pack' and ... do something.
  I'll write that code at some point after we work out
  the details.
4. If you want edit other stuff too, like the descriptions
5. Open the index file in your browser. Something like
    http://localhost/somewhere/sahli/index.html
or if it's on the web, then:
    http://www.example.com/ansiasciicompo/sahli/index.html
6. When it says things are loaded, hit 'space' - OR ? or h
   ? and h are "help"
7. Everything is done by keys.
8. Ok on a tablet tap corners and stuff, cuz no keys.

- Great so yeah why is it 'Sahli'

Because I call Sal-One 'sally' and this is sort of close to
how one might say it if you had a bad Finnish accent, rather
than a Truck-can't-speak-Finnish-well accent.

- Example files are from Breakpoint 2013's compo, credits:
H7/Blocktronics/Accession, Urs/Mercury, Ted/Pöo-crüe^3ln,
Azzarro/Madwizards.
