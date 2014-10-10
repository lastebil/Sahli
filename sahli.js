//  .___________________________________,       ___
//  |            /      |   |      .     \    .(___):
//  |        _______    |          :      \   :     |
//: |___/      /        |          |       \__|     |
//|           /         |          |          |     |
//l__________/__________|___|______l__________j_____j
//
//     Ansi/Ansi Viewer in Ecmascript
// Coded by Sir Garbagetruck / Accession 2013
// Uses fonts by DMG, http://trueschool.se
// Uses SixteenColors textmode js library for rendering

/* remove this before publishing, as alert is ... well just crap to leave in */
/*global alert */
// but don't remove these

/*global XMLHttpRequest, AnsiLove, Element */

var Sahli = function () {
    this.outbox = $('div#outbox');
    this.dbox = $('div#drawbox');
    this.image = 0;

    // scroll speed of 5 looks ... "ok" on macbook pro. 4 was original.
    this.scroll_speed = 5;
    this.scroll_direction = 1;
    this.zoomspeed = 200;
    this.asciiasgfx = true; // changed at Evoke as the 16colors amiga bits aren't the same as old lib.
    // You need to submit your fixes/changes to them, truck...
    this.DEBUG = false;

    this.dbox.height(document.height - 24);
    this.dbox.width(document.width - 2);
    this.sizemult = 16; // 32 is larger than screen, and somewhat silly
    this.origheight = 0;
    this.origwidth = 0;
    this.filedata = '';
    this.slides = 0;
    this.currentpic = 0;
    this.nonfsheight = document.height - 40;

    this.loadpic = function (picdata, inserthere) {
        switch (picdata.filetype) {
        case 'plain':
            this.loadplain(picdata, inserthere);
            break;
        case 'ansi':
            this.loadhugeansi(picdata, inserthere);
            break;
        case 'bin':
            this.loadansi(picdata, inserthere);
            break;
        case 'xbin':
            this.loadansi(picdata, inserthere);
            break;
        case 'ice':
            this.loadansi(picdata, inserthere);
            break;
        case 'avatar':
            this.loadavatar(picdata, inserthere);
            break;
        case 'pcboard':
            this.loadansi(picdata, inserthere);
            break;
        case 'idf':
            this.loadansi(picdata, inserthere);
            break;
        case 'adf':
            this.loadansi(picdata, inserthere);
            break;
        case 'tundra':
            this.loadansi(picdata, inserthere);
            break;
        default:
            this.loadplain(picdata, inserthere);
        }
    };

    this.loadplain = function (picdata, inserthere) {
        var pdiv = $('<div>');
        var req = new XMLHttpRequest();
        var fname = this.location + '/' + picdata.file;
        var ptxt = $('<pre></pre>');
        var color = this.calccolor(picdata.color);
        var bgcolor = this.calccolor(picdata.bg);

        pdiv.addClass('scrolly');
        ptxt.addClass(picdata.font.toLowerCase());
        ptxt.css({
            'color': color,
            'background-color': bgcolor,
            'margin': 'auto'
        });
        ptxt.width(picdata.width * 8);
        pdiv.width('100%');
        pdiv.append(ptxt);
        // x-user-defined
        // this is going to be interesting when dealing with ansi files in UTF-8 and SHIFT-JIS etc
        req.overrideMimeType('text/plain; charset=ISO-8859-1');
        req.onreadystatechange = function () {
            if (req.readyState === req.DONE) {
                if (req.status === 200 || req.status === 0) {
                    ptxt.text(this.responseText);
                    inserthere.after(pdiv);
                } else {
                    this.loaderror(inserthere, fname, req.statusText, req.status);
                }
            }
        };
        req.open('GET', fname, true);
        req.send(null);
    };

    this.loadansi = function (picdata, inserthere) {
        var fname = this.location + '/' + picdata.file;
//        var canv = document.createElement('canvas');
        var pdiv = $('<div>');
//        var SAUCE;
        AnsiLove.render(fname, function (canv, SAUCE) {
            pdiv.append(canv);
            inserthere.after(pdiv);
            this.origwidth = canv.width;
            this.origheight = canv.height;
            this.SAUCE = SAUCE;
        }, {"font": "80x25", "bits": "8", "columns": 160, "thumbnail": 0});
    };

    this.loadhugeansi = function (picdata, inserthere) {
        var fname = this.location + '/' + picdata.file;
        var pdiv = $('<div>');
        var calcheight = 0;
        var canvwidth = 0;
        pdiv.css('display', 'inline-block');
        AnsiLove.splitRender(fname, function (chunks, SAUCE) {
            chunks.forEach(function (canv) {
                canv.style.verticalAlign = "bottom";
                pdiv.append(canv);
                calcheight = calcheight + canv.height;
                canvwidth = canv.width;
            });
            inserthere.after(pdiv);
            this.SAUCE = SAUCE;
            this.origwidth = canvwidth;
            this.origheight = calcheight;
            pdiv.width(canvwidth);
        }, 30, {"bits": "8"});
    };

    this.loadavatar = function (picdata, inserthere) {
        alert('avatar', picdata, inserthere);
    };

    this.fillinfo = function (picdata) {
        var infob = $('div.infobox');
        infob.find('h1').text(picdata.name);
        infob.find('h2').text(picdata.author);
        infob.find('h3#text').text(picdata.line1);
        infob.find('h3#text2').text(picdata.line2);
        infob.find('.bigtext').text(picdata.text);
        infob.find('span#filename').text(picdata.file);
        infob.find('span#infowidth').text("| " + picdata.width + " cols |");
        infob.find('span#fontname').text(picdata.font);
    };

    this.loaderror = function (inserthere, fname, errorText, errorCode) {
        var temptxt = "";
        if (errorCode === 404) {
            temptxt = $("<h1>").text("Unable to find file " + fname);
        } else {
            temptxt = $("<h1>").text("error! " + errorText + " code " + errorCode +
                " file " + fname);
        }
        inserthere.after(temptxt);
    };

    this.calccolor = function (colorset) {
        return 'rgba(' + colorset.toString() + ')';
    };

    this.resize = function (amt) {
        var canv = $('canvas');
        var w = canv.width() * amt;
        var h = canv.height() * amt;
        canv.animate({
            width: w,
            height: h
        }, this.zoomspeed);
    };

    this.fullwidth = function () {
        this.stopscroll();
        if ($('canvas').width() === this.dbox.width()) {
            this.originalsize(this.zoomspeed);
        } else {
            var ratio = this.origwidth / this.dbox.width();
            $('canvas').animate({
                width: this.dbox.width(),
                height: this.origheight / ratio
            }, this.zoomspeed);

        }
    };

    this.fullheight = function () {
        var canv = $('canvas');
        if (canv.height() === this.dbox.height()) {
            this.originalsize(this.zoomspeed);
        } else {
            var ratio = this.origheight / this.dbox.height();
            canv.animate({
                height: this.dbox.height(),
                width: this.origwidth / ratio
            }, this.zoomspeed);
        }
    };

    this.originalsize = function (zoomspeed) {
        // why do we not have origwidth now? hmm.
        var canv = $('canvas');
        var zs = zoomspeed;  // why are we not using this?
        zs = zs + 1;
        canv.animate({
            width: this.origwidth,
            height: this.origheight
        }, this.zoomspeed);
    };


    this.toptext = function (text) {
        if (this.DEBUG) {
            $('h1#top').text(text);
        }
    };

    this.setscroll = function () {
        var bottom = $('.scrolly').height();
        var scrollto = bottom;
        var steps;
        // kill animations from before
        this.dbox.stop(true);
        if (this.scroll_direction === 1) {
            this.scroll_direction = -1;
            steps = bottom - this.dbox.scrollTop();
        } else {
            this.scroll_direction = 1;
            scrollto = 0;
            steps = this.dbox.scrollTop();
        }
        this.toptext(this.scroll_speed + ' | ' + steps);

        this.dbox.animate({
            scrollTop: scrollto
        }, this.scroll_speed * steps, 'linear');
    };

    this.resizedrawbox = function (height) {
        var dbox1 = $('div#drawbox');
        if ('undefined' === height) {
            dbox1.height(window.innerHeight - 2);
        } else {
            dbox1.height(height);
        }
        dbox1.width(window.innerWidth - 2);
    };

    this.stopscroll = function () {
        this.dbox.stop(true);
    };

    this.moveabout = function (lines) {
        var line = this.dbox.scrollTop();
        this.dbox.stop(true);
        switch (lines) {
        case 0:
            this.dbox.scrollTop(0);
            break;
        case Infinity:
            this.dbox.scrollTop(this.origheight);
            break;
        default:
            this.dbox.scrollTop(line - lines * 8);
            break;
        }
    };

    this.requestsahlifile = function (url) {
        var ref = this;
        $.getJSON(url, function (json) {
            ref.filedata = json.filedata;
            ref.slides = json.slides;
            ref.location = json.location;
            ref.buildcompo();
        });
    };


    this.buildcompo = function () {
        this.resizedrawbox();
        alert("SAHLI READY TO GO");
    };

    this.nextpic = function () {
        this.dbox.children().remove();
        // reset scrolling;
        this.stopscroll();
        this.scroll_direction = 1;
        var i = this.currentpic;
        var filedata = this.filedata;
        filedata[i].pic = $("<h6>" + filedata[i].file + "</h6>");
        this.dbox.append(filedata[i].pic);
        this.loadpic(filedata[i], filedata[i].pic);
        this.currentpic += 1;
        if (this.currentpic > filedata.length - 1) {
            this.currentpic = 0;
        }
    };


    this.gofullscreen = function () {
        var docElm = document.documentElement;
        window.setTimeout(this.resizedrawbox, 100);
        if (docElm.requestFullscreen) {
            docElm.requestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        } else if (docElm.mozRequestFullScreen) {
            docElm.mozRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        } else if (docElm.webkitRequestFullScreen) {
            docElm.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        }

    };

    this.cancelfullscreen = function () {
        window.setTimeout(this.resizedrawbox, 100, this.nonfsheight);
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        }
    };

    this.fixhelpbox = function () {
        var h = $('.help');
        //        var xy = {'top': document.height/2 - h.height()/2, 'left': document.width/2 - h.width()/2};
        var xy = {
            'top': 0,
            'left': document.width / 2 - h.width() / 2
        };
        h.css(xy);
    };

    this.toggledebug = function () {
        $('h1#top').fadeToggle();
        this.DEBUG = (!this.DEBUG);
    };

    this.loadkeys = function () {
        var ref = this;
        $(document).bind('click', function (ev) {
            if (ev.clientY < 100) {
                if (ev.clientX < 100) {
                    ref.nextpic();
                } else {
                    ref.fullwidth();
                }
            } else {
                ref.setscroll();
            }
        });

        $(document).bind('keydown', function (ev) {
            switch (ev.which) {
            case 84: // t
                ref.asciiasgfx = (!ref.asciiasgfx);
                ref.toptext(ref.asciiasgfx);
                break;
            case 85: // u
            case 9: // u
                $('div.infobox').slideToggle('slow');
                break;
            case 70: // f
                ref.gofullscreen();
                break;
            case 27: // esc
            case 71: // G, as escape seems to not get passed from fullscreen on chrome
                ref.cancelfullscreen();
                break;
            case 73: // i
                ref.resize(2);
                break;
            case 75: // k
                ref.resize(0.5);
                break;
            case 79: // o
                ref.fullwidth();
                break;
            case 76: // l
                ref.fullheight();
                break;
            case 80: // p
                ref.originalsize(0);
                break;

            case 83: // s
                ref.setscroll();
                break;
            case 72: // h
            case 191: // "?" (also / but no shift)
                $('.help').fadeToggle('fast');
                break;
            case 107: // +
            case 190: // .
                ref.scroll_speed = ref.scroll_speed * 2;
                ref.toptext("speed doubled:" + ref.scroll_speed);
                break;
            case 109: // -
            case 188: // ,
                ref.scroll_speed = ref.scroll_speed / 2;
                ref.toptext("speed halved:" + ref.scroll_speed);
                break;
            case 49: // 1
                ref.scroll_speed = 1;
                break;
            case 50: //2
                ref.scroll_speed = 2;
                break;
            case 51: //3
                ref.scroll_speed = 3;
                break;
            case 52: //4
                ref.scroll_speed = 4;
                break;
            case 53: //5
                ref.scroll_speed = 5;
                break;
            case 220: // "\"
                ref.toptext(ref.scroll_speed);
                break;
            case 8: // backspace
            case 68: // D
                ref.stopscroll();
                break;
                // move about keys
            case 33: // pgup
                ref.moveabout(24);
                break;
            case 34: // pgdwn
                ref.moveabout(-24);
                break;
            case 36: // home
                ref.moveabout(0);
                break;
            case 35: // end
                ref.moveabout(Infinity);
                break;
            case 40: // down
                ref.moveabout(-1);
                break;
            case 32: // space
                ref.nextpic();
                break;
            case 38: // up
                ref.moveabout(1);
                break;
            case 19: // pause/break
            case 121: // F10
                ref.toggledebug();
                break;
                // debug alerts for these keys are annoying (:
            case 116: // f5
            case 123: // f12
                break;
            default:
                if (ref.DEBUG) {
                    alert(ev.which);
                }
                break;
            }
        });
    };

    this.loadkeys();
    //    this.loadpic('h7-r2012.ans',this.dbox);
    this.fixhelpbox();
    var ref = this;
    $(window).resize(function () {
        ref.resizedrawbox();
    });
    this.requestsahlifile('list.sahli');

};

// I switched to Sublime text + sublemacs pro.
// Yes, the author of Sublime Text's emacs hatred is annoying.