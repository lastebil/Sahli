// Generated by CoffeeScript 1.4.0

/*
  .___________________________________,       ___
  |            /      |   |      .     \    .(___):
  |        _______    |          :      \   :     |
: |___/      /        |          |       \__|     |
|           /         |          |          |     |
l__________/__________|___|______l__________j_____j

     Ansi/Ansi Viewer in Ecmascript
 Coded by Sir Garbagetruck / Accession 2013
 Uses fonts by DMG, http://trueschool.se
 Uses Andy Herbert's Ansilove.js for rendering.
*/


(function() {

  this.Sahli = (function() {
    var _this = this;

    function Sahli() {}

    Sahli.loadpic = function(picdata, inserthere) {
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

    Sahli.loadplain = function(picdata, inserthere) {
      var bgcolor, color, fname, pdiv, ptxt, req;
      pdiv = $('<div>');
      req = new XMLHttpRequest;
      fname = this.location + '/' + picdata.file;
      ptxt = $('<pre></pre>');
      color = this.calccolor(picdata.color);
      bgcolor = this.calccolor(picdata.bg);
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
      req.overrideMimeType('text/plain; charset=ISO-8859-1');
      req.onreadystatechange = function() {
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

    Sahli.loadansi = function(picdata, inserthere) {
      var fname, pdiv;
      fname = this.location + '/' + picdata.file;
      pdiv = $('<div>');
      AnsiLove.render(fname, (function(canv, SAUCE) {
        pdiv.append(canv);
        inserthere.after(pdiv);
        this.origwidth = canv.width;
        this.origheight = canv.height;
        this.SAUCE = SAUCE;
      }), {
        'font': '80x25',
        'bits': '8',
        'columns': 160,
        'thumbnail': 0
      });
    };

    Sahli.loadhugeansi = function(picdata, inserthere) {
      var calcheight, canvwidth, fname, pdiv;
      fname = this.location + '/' + picdata.file;
      pdiv = $('<div>');
      calcheight = 0;
      canvwidth = 0;
      pdiv.css('display', 'inline-block');
      AnsiLove.splitRender(fname, (function(chunks, SAUCE) {
        chunks.forEach(function(canv) {
          canv.style.verticalAlign = 'bottom';
          pdiv.append(canv);
          calcheight = calcheight + canv.height;
          canvwidth = canv.width;
        });
        inserthere.after(pdiv);
        this.SAUCE = SAUCE;
        this.origwidth = canvwidth;
        this.origheight = calcheight;
        pdiv.width(canvwidth);
      }), 30, {
        'bits': '8'
      });
    };

    Sahli.loadavatar = function(picdata, inserthere) {
      alert('avatar', picdata, inserthere);
    };

    Sahli.requestsahlifile = function(url) {
      var _this = this;
      this.loadkeys();
      this.DEBUG = false;
      this.scroll_speed = 5;
      this.scroll_direction = 1;
      this.asciiasgfx = false;
      this.currentpic = 0;
      return $.getJSON(url, function(json) {
        _this.filedata = json.filedata;
        _this.slides = json.slides;
        _this.location = json.location;
        return alert("SAHLI READY TO GO\n" + _this.filedata.length + " Entries");
      });
    };

    Sahli.nextpic = function() {
      var filedata, i;
      $('div#sahliviewer').children().remove();
      i = Sahli.currentpic;
      filedata = Sahli.filedata;
      filedata[i].pic = $('<h6>' + filedata[i].file + '</h6>');
      Sahli.viewbox.append(filedata[i].pic);
      Sahli.loadpic(filedata[i], filedata[i].pic);
      Sahli.currentpic += 1;
      if (Sahli.currentpic > filedata.length - 1) {
        Sahli.currentpic = 0;
      }
    };

    Sahli.gofullscreen = function() {
      var docElm;
      docElm = document.documentElement;
      window.setTimeout(this.resizedrawbox, 100);
      if (docElm.requestFullscreen) {
        docElm.requestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
      } else if (docElm.mozRequestFullScreen) {
        docElm.mozRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
      } else if (docElm.webkitRequestFullScreen) {
        docElm.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
      }
    };

    Sahli.cancelfullscreen = function() {
      window.setTimeout(this.resizedrawbox, 100, this.nonfsheight);
      if (document.exitFullscreen) {
        document.exitFullscreen();
      } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
      } else if (document.webkitCancelFullScreen) {
        document.webkitCancelFullScreen();
      }
    };

    Sahli.toggledebug = function() {
      $('h1#top').fadeToggle();
      this.DEBUG = !this.DEBUG;
    };

    Sahli.keycode = function(char) {
      return char.toUpperCase().charCodeAt(0);
    };

    Sahli.loadkeys = function() {
      var _this = this;
      return $(document).on('keydown', function(ev) {
        switch (ev.which) {
          case _this.keycode(' '):
            return _this.nextpic();
          case _this.keycode('s'):
            return alert("not spaaaace");
          default:
            return console.log(ev.which);
        }
      });
    };

    return Sahli;

  }).call(this);

}).call(this);
