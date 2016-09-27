      .___________________________________,       ___
      |            /      |   |      .     \    .(___):
      |        _______    |          :      \   :     |
    : |___/      /        |          |       \__|     |
    |           /         |          |          |     |
    l__________/__________|___|______l__________j_____j

               Ansi/Ansi Viewer in Ecmascript
        Coded by Sir Garbagetruck / Accession 2013+
          Uses fonts by DMG, http:trueschool.se
     Uses SixteenColors textmode js library for rendering
            (well, my optimized version...)
                      Version B
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
well, fairly well.  It has been used at Revision,
Evoke, and Payback, and the folks who saw their stuff in
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

For Chrome/Chromium:

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

Mr Doob (who I want to call Trace (: ) has a good page
explaining how to do this and alternatives here:

https://github.com/mrdoob/three.js/wiki/How-to-run-things-locally

Firefox (and Icecat, possibly other Firefox codebased browsers)
seem to work today (Sept 2016) _without_ making any changes, so
you can use it 'out of the box.'  M0qui was able to, and I tested,
and so the big 72-point "not supported on Windows+Firefox" warning
goes away.

Again, DON'T FREAKING TURN OFF JAVASCRIPT SECURITY AND FORGET TO
TURN IT BACK ON.  DON'T.  NOT JUST ON WINDOWS.  BUT ESPECIALLY ON
WINDOWS.

I may be able to turn this into a chrome app at some point, which
will eliminate that issue.  Possibly also a Firefox solution, but:
As of today: I do not support this on Windows + Firefox.  That is
100% at your own risk, because of the possibility you will forget
to set the setting back.

It's just plain safer to install this on your webserver at the
party place in a directory and use _that._

This product is licensed under the WTFPL.  See:
             http://www.wtfpl.net
for details, or just get the license:
        http://www.wtfpl.net/txt/copying/

 * tl;dr wtf omg how duz thz wrk omg wtf

1. Place the important files (.js, .css, .html, .sahli)
 on a webserver or local directory.
2. Put your ansi and ascii files on the webserver / local
 directory. (Or unpack your colly, etc...)
3. Fire up the editor and set up the .sahli file.
 Alternately, edit it as JSON.  (Just be sure it's 100%
 correct or your show won't go like you planned.)
5. Open the index file in your browser. Something like
    http://localhost/somewhere/sahli/index.html
  ** or if it's on the web, then:
    http://www.example.com/ansiasciicompo/sahli/index.html
6. When it says things are loaded, hit 'space' - OR ? or h
   ? and h are "help"
7. Everything is done by keys.
8. On a tablet tap corners and stuff, cuz no keys.

- Great so yeah why is it 'Sahli'

Because I call Sal-One 'sally' and this is sort of close to
how one might say it if you had a bad Finnish accent, rather
than a Truck-can't-speak-Finnish-well accent.

- Example files are from Breakpoint 2013's compo, credits:
H7/Blocktronics/Accession, Urs/Mercury, Ted/Pöo-crüe^3ln,
Azzarro/Madwizards.
- More examples came from 16colors archive. When the final
Sahli ver. B comes out, I'll select some test files and
put those credits in here too.

- Thanks to M0qui for submitting a patch for 'backwards'
(in case you accidentally hit space.  Which we c64 sceners
never do, because that would be the NEXT demopart, and
you'd have to reload (:  )
