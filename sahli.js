// Generated by CoffeeScript 1.9.3

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
    function Sahli() {
      $('body').css('cursor', 'none');
    }

    Sahli.loadpic = function(picdata, inserthere) {
      switch (picdata.filetype) {
        case 'plain':
          return this.loadplain(picdata, inserthere);
        case 'ansi':
          return this.loadhugeansi(picdata, inserthere);
        case 'bin':
          return this.loadhugeansi(picdata, inserthere);
        case 'xbin':
          return this.loadhugeansi(picdata, inserthere);
        case 'ice':
          return this.loadhugeansi(picdata, inserthere);
        case 'avatar':
          return this.loadavatar(picdata, inserthere);
        case 'pcboard':
          return this.loadhugeansi(picdata, inserthere);
        case 'idf':
          return this.loadhugeansi(picdata, inserthere);
        case 'adf':
          return this.loadhugeansi(picdata, inserthere);
        case 'tundra':
          return this.loadhugeansi(picdata, inserthere);
        case 'image':
          return this.loadpicture(picdata, inserthere);
        default:
          return this.loadplain(picdata, inserthere);
      }
    };

    Sahli.loadplain = function(picdata, inserthere) {
      var bgcolor, buf, color, fname, pdiv, ptxt, req;
      pdiv = $('<div>');
      req = new XMLHttpRequest;
      fname = this.location + '/' + picdata.file;
      buf = $('<span>');
      buf.css({
        'margin': '0 auto'
      });
      ptxt = $('<pre>');
      ptxt.addClass('plaintext');
      color = this.calccolor(picdata.color);
      bgcolor = this.calccolor(picdata.bg);
      pdiv.addClass('scrolly');
      ptxt.addClass(picdata.font.toLowerCase());
      ptxt.css({
        'color': color,
        'background-color': bgcolor,
        'margin': 'auto',
        'display': 'inline-block'
      });
      pdiv.prepend(buf.clone());
      pdiv.append(ptxt);
      pdiv.append(buf);
      req.overrideMimeType('text/plain; charset=ISO-8859-1');
      req.onreadystatechange = function() {
        if (req.readyState === req.DONE) {
          if (req.status === 200 || req.status === 0) {
            ptxt.text(this.responseText);
            inserthere.after(pdiv);
            return $('body').scrollTop(0);
          } else {
            return this.loaderror(inserthere, fname, req.statusText, req.status);
          }
        }
      };
      req.open('GET', fname, true);
      return req.send(null);
    };

    Sahli.increaseFont = function(node, increaseBy) {
      var current_size;
      if (increaseBy == null) {
        increaseBy = 5;
      }
      current_size = parseInt($(node).css("font-size"));
      return $(node).css("font-size", current_size + increaseBy);
    };

    Sahli.loadpicture = function(picdata, inserthere) {
      var fname, pdiv, pimg;
      fname = this.location + '/' + picdata.file;
      pdiv = $('<div>');
      pdiv.addClass('scrolly');
      pdiv.addClass('image');
      pdiv.width(window.innerWidth);
      pdiv.css('display', 'inline-block');
      pimg = $('<img src="' + fname + '" />');
      pimg.addClass('fullwidth');
      pdiv.append(pimg);
      inserthere.after(pdiv);
      $('h6').hide();
      $('body').scrollTop(0);
      this.origwidth = picdata.width;
      this.origheight = picdata.height;
      return this.bestfit();
    };

    Sahli.bestfit = function() {
      if ($('div.scrolly').hasClass('image')) {
        if ($('div.scrolly').hasClass('bestfitMode')) {
          $('div.scrolly').removeClass('bestfitMode');
          $('div.scrolly').addClass('fullwidthMode');
          $('div.scrolly').width(window.innerWidth);
          $('div.scrolly').height("");
          $('img.bestfit').addClass('fullwidth');
          return $('img.bestfit').removeClass('bestfit');
        } else {
          $('h6').hide();
          $('div.scrolly').addClass('bestfitMode');
          $('div.scrolly').removeClass('fullwidthMode');
          $('div.scrolly').width(window.innerWidth);
          $('div.scrolly').height(window.innerHeight);
          $('img.fullwidth').addClass('bestfit');
          return $('img.fullwidth').removeClass('fullwidth');
        }
      }
    };

    Sahli.loadhugeansi = function(picdata, inserthere) {
      var calcheight, canvwidth, fname, pdiv;
      fname = this.location + '/' + picdata.file;
      pdiv = $('<div>');
      calcheight = 0;
      canvwidth = 0;
      pdiv.css('display', 'inline-block');
      pdiv.addClass('scrolly');
      return AnsiLove.splitRender(fname, ((function(_this) {
        return function(chunks, SAUCE) {
          chunks.forEach(function(canv) {
            canv.style.verticalAlign = 'bottom';
            pdiv.append(canv);
            calcheight = calcheight + canv.height;
            return canvwidth = canv.width;
          });
          inserthere.after(pdiv);
          $('body').scrollTop(0);
          _this.SAUCE = SAUCE;
          _this.origwidth = canvwidth;
          _this.origheight = calcheight;
          return pdiv.width(canvwidth);
        };
      })(this)), 30, {
        'bits': '8',
        "font": picdata.font
      });
    };

    Sahli.loadavatar = function(picdata, inserthere) {
      return console.log('avatar', picdata, inserthere);
    };

    Sahli.requestsahlifile = function(url) {
      this.loadkeys();
      this.DEBUG = false;
      this.fullscreen = false;
      this.scroll_speed = 5;
      this.scroll_direction = 1;
      this.asciiasgfx = false;
      this.currentpic = 0;
      return $.getJSON(url, (function(_this) {
        return function(json) {
          _this.filedata = json.filedata;
          _this.slides = json.slides;
          _this.location = json.location;
          return alert("SAHLI READY TO GO\n" + _this.filedata.length + " Entries\nH for Help\nSpace to Start");
        };
      })(this));
    };

    Sahli.loadinfopanel = function(index) {
      var data;
      data = this.filedata[index];
      $('.infobox h1').text(data.name);
      $('.infobox h2').text(data.author);
      $('h3.infobox')[0].textContent = data.line1;
      $('h3.infobox')[1].textContent = data.line2;
      $('p.bigtext').text(data.text);
      $('.infobox span')[0].textContent = data.filename;
      $('.infobox span')[1].textContent = data.width;
      return $('.infobox span')[2].textContent = data.font;
    };

    Sahli.nextpic = function() {
      var filedata, i, viewbox;
      viewbox = $('div#sahliviewer');
      viewbox.children().remove();
      $('#panel').empty();
      Sahli.scroll_direction = 1;
      Sahli.scroll_speed = 5;
      i = Sahli.currentpic;
      filedata = Sahli.filedata;
      filedata[i].pic = $('<h6>' + filedata[i].file + '</h6>');
      viewbox.append(filedata[i].pic);
      $('h6').show();
      Sahli.loadpic(filedata[i], filedata[i].pic);
      Sahli.currentpic += 1;
      if (Sahli.currentpic > filedata.length - 1) {
        Sahli.currentpic = 0;
      }
      $('#panel').hide();
      $('#outbox').show();
      $('body').stop();
      return Sahli.loadinfopanel(i);
    };

    Sahli.prevpic = function() {
      var i;
      i = Sahli.currentpic - 2;
      if (i < 0) {
        i = i + Sahli.filedata.length;
      }
      Sahli.currentpic = i;
      return Sahli.nextpic();
    };

    Sahli.togglefullscreen = function() {
      var docElm;
      docElm = document.documentElement;
      if (this.fullscreen) {
        if (document.exitFullscreen) {
          document.exitFullscreen();
        } else if (document.mozCancelFullScreen) {
          document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
          document.webkitCancelFullScreen();
        }
        return this.fullscreen = false;
      } else {
        if (docElm.requestFullscreen) {
          docElm.requestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        } else if (docElm.mozRequestFullScreen) {
          docElm.mozRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        } else if (docElm.webkitRequestFullScreen) {
          docElm.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
        }
        return this.fullscreen = true;
      }
    };

    Sahli.toggledebug = function() {
      $('h1#top').fadeToggle();
      return this.DEBUG = !this.DEBUG;
    };

    Sahli.keycode = function(char) {
      return char.toUpperCase().charCodeAt(0);
    };

    Sahli.calccolor = function(colorset) {
      return "rgba(" + (colorset.toString()) + ")";
    };

    Sahli.loaderror = function(inserthere, fname, errortext, errorcode) {
      var errstr;
      if (errorcode === 404) {
        errstr = "Unable to find " + fname;
      } else {
        errstr = "error! " + errortext + " / code " + errorcode;
      }
      return inserthere.after($("<h1>").text("" + errstr));
    };

    Sahli.setscroll = function() {
      var bottom, scrollbox, scrollto, steps;
      scrollbox = $('body');
      bottom = $('body').height();
      scrollto = bottom;
      scrollbox.stop(true);
      if (this.scroll_direction === 1) {
        this.scroll_direction = -1;
        steps = bottom - scrollbox.scrollTop();
      } else {
        this.scroll_direction = 1;
        scrollto = 0;
        steps = scrollbox.scrollTop();
      }
      console.log(this.scroll_speed + " | " + steps);
      return scrollbox.animate({
        scrollTop: scrollto
      }, this.scroll_speed * steps, 'linear');
    };

    Sahli.changespeed = function(speed) {
      this.scroll_speed = speed;
      $('body').stop();
      this.scroll_direction = -this.scroll_direction;
      return this.setscroll();
    };

    Sahli.moveline = function(direction) {
      var curpos;
      curpos = $('body').scrollTop();
      return $('body').scrollTop(curpos + (16 * direction));
    };

    Sahli.changescrolldirection = function(direction) {
      this.scroll_direction = direction;
      $('body').stop();
      return this.setscroll();
    };

    Sahli.zoom = function(amt) {
      var newwidth, zoomee;
      zoomee = $('div.scrolly');
      if (amt != null) {
        if (amt === 0) {
          newwidth = this.origwidth;
        } else {
          newwidth = zoomee.width() + amt;
        }
        zoomee.width(newwidth);
        return $('canvas').width(newwidth);
      } else {
        if (parseInt(zoomee.width(), 10) !== parseInt(this.origwidth, 10)) {
          zoomee.width(this.origwidth);
          return $('canvas').width('100%');
        } else {
          zoomee.width('100%');
          return $('canvas').width('100%');
        }
      }
    };

    Sahli.panelmode = function() {
      var canvs, ct, drawcol, j, k, len, len1, level, newheight, newwidth, numcols, numpanels, outer, panelratio, panelslotheight, panelsperslot, pic, picdpercol, results, screenratio, wh, ww, x;
      $('#panel').toggle();
      canvs = $('canvas');
      $('.scrolly').width(this.origwidth);
      if ($('#panel').css('display') !== 'none') {
        $('#panel').empty();
        ww = window.innerWidth;
        wh = window.innerHeight;
        numpanels = canvs.length;
        screenratio = ww / wh;
        panelratio = canvs[0].height / canvs[0].width;
        x = Math.sqrt(numpanels / screenratio);
        numcols = Math.round(screenratio * x);
        picdpercol = Math.round(numpanels / numcols);
        newwidth = ww / numcols;
        canvs.width(newwidth);
        newheight = canvs.height();
        panelsperslot = Math.floor(wh / newheight);
        panelslotheight = panelsperslot * newheight;
        outer = $('<div>');
        console.log(numcols);
        outer.addClass('nosb');
        $('#panel').append(outer);
        $('#outbox').toggle();
        level = 0;
        drawcol = 1;
        ct = 0;
        outer.append(this.createpanel(1, newwidth - 6));
        results = [];
        for (j = 0, len = canvs.length; j < len; j++) {
          pic = canvs[j];
          $("#column" + drawcol).append(pic);
          level += 1;
          ct += 1;
          if (level === panelsperslot) {
            level = 0;
            drawcol = drawcol + 1;
            if (ct < numpanels) {
              results.push(outer.append(this.createpanel(drawcol, newwidth - 6)));
            } else {
              results.push(void 0);
            }
          } else {
            results.push(void 0);
          }
        }
        return results;
      } else {
        $('#outbox').show();
        for (k = 0, len1 = canvs.length; k < len1; k++) {
          pic = canvs[k];
          $('.scrolly').append(pic);
        }
        canvs.width(this.origwidth);
        return $('body').scrollTop(0);
      }
    };

    Sahli.createpanel = function(i, amt) {
      var dcol;
      dcol = $("<div id='column" + i + "' class='panelcolumn'>" + i + "</div>");
      return dcol.width(amt);
    };

    Sahli.loadkeys = function() {
      $(document).on('click', (function(_this) {
        return function(ev) {
          var clickx, clicky, wh, ww;
          clickx = ev.clientX;
          clicky = ev.clientY;
          wh = window.innerHeight;
          ww = window.innerWidth;
          if (clicky > wh - 100) {
            _this.nextpic();
          }
          if (clicky < 100) {
            _this.setscroll();
          }
          if (clicky > 100 && clicky < wh - 100) {
            if (clickx < 100) {
              _this.togglefullscreen();
            }
            if (clickx > ww - 100) {
              return _this.panelmode();
            }
          }
        };
      })(this));
      return $(document).on('keydown', (function(_this) {
        return function(ev) {
          switch (ev.which) {
            case _this.keycode(' '):
              return _this.nextpic();
            case _this.keycode('p'):
              return _this.prevpic();
            case _this.keycode('f'):
              return _this.togglefullscreen();
            case _this.keycode('s'):
              return _this.setscroll();
            case _this.keycode('t'):
              $('body').scrollTop(0);
              return _this.zoom(0);
            case _this.keycode('b'):
              return $('body').scrollTop($('body').height());
            case _this.keycode('a'):
              $('body').stop();
              return _this.scroll_direction = -_this.scroll_direction;
            case _this.keycode('z'):
              return _this.zoom();
            case _this.keycode('e'):
              return _this.zoom(100);
            case _this.keycode('r'):
              return _this.zoom(-100);
            case _this.keycode('q'):
              return _this.bestfit();
            case _this.keycode('w'):
              return _this.changescrolldirection(-1);
            case _this.keycode('x'):
              return _this.changescrolldirection(1);
            case _this.keycode('c'):
              return _this.panelmode();
            case _this.keycode('i'):
              return $('div.infobox').toggle();
            case _this.keycode('v'):
              $('h6').show();
              return $('h6').height((window.innerHeight - $('.scrolly').height()) / 2);
            case _this.keycode('1'):
              return _this.changespeed(1);
            case _this.keycode('2'):
              _this.changespeed(2);
              return _this.scroll_speed = 2;
            case _this.keycode('3'):
              _this.changespeed(3);
              return _this.scroll_speed = 3;
            case _this.keycode('4'):
              _this.changespeed(4);
              return _this.scroll_speed = 4;
            case _this.keycode('5'):
              return _this.changespeed(5);
            case _this.keycode('8'):
              return _this.increaseFont($('pre'), -2);
            case _this.keycode('9'):
              return _this.increaseFont($('pre'), 2);
            case _this.keycode('0'):
              return $('pre').css("font-size", "2.5vw");
            case 40:
              return _this.moveline(1);
            case 38:
              return _this.moveline(-1);
            case 34:
              return _this.moveline(40);
            case 33:
              return _this.moveline(-40);
            case _this.keycode('h'):
              $('.help').css({
                'left': '33%'
              });
              return $('.help').toggle('fast');
            default:
              return console.log(ev.which);
          }
        };
      })(this));
    };

    return Sahli;

  })();

}).call(this);
