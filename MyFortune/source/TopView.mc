using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Communications as Comm;

    const SOURCES = {
        "esr" => "Eric S. Raymond",
        "humorix_misc" => "Humorix (misc)",
        "humorix_stories" => "Humorix (stories)",
        "joel_on_software" => "Joel on Software",
        "macintosh" => "On Macintosh",
        "math" => "Math",
        "mav_flame" => "Marc A. Volovic",
        "osp_rules" => "Rule of Open-Source Programming",
        "paul_graham" => "Paul Graham",
        "prog_style" => "The Elements of Programming Style",
        "subversion" => "Subversion",
        "1811_dictionary_of_the_vulgar_tongue" => "The Vulgar Tongue",
        "codehappy" => "Code Happy",
        "fortune" => "Fortune",
        "liberty" => "On Liberty",
        "literature" => "Literature",
        "misc" => "Misc.",
        "murphy" => "Murphy",
        "oneliners" => "One Liners",
        "riddles" => "Riddles",
        "rkba" => "Right to Keep and Bear Arms",
        "shlomif" => "Shlomi Fish",
        "shlomif_fav" => "Shlomi Fish Favorites",
        "stephen_wright" => "Stephen Wright",
        "calvin" => "Calvin&Hobbes",
        "forrestgump" => "Forrest Gump",
        "friends" => "Friends",
        "futurama" => "Futurama",
        "holygrail" => "Holy Grail",
        "powerpuff" => "Powerpuff",
        "simon_garfunkel" => "Simon&Garfunkel",
        "simpsons_cbg" => "Simpsons - Comic Book Guy",
        "simpsons_chalkboard" => "Simpsons - Chalkboard",
        "simpsons_homer" => "Simpsons - Homer",
        "simpsons_ralph" => "Simpsons - Ralph",
        "south_park" => "South Park",
        "starwars" => "Star Wars",
        "xfiles" => "X-Files",
        "bible" => "The Bible",
        "contentions" => "Contentions",
        "osho" => "Osho",
        "cryptonomicon" => "Cryptonomicon",
        "discworld" => "Disc World",
        "dune" => "Dune",
        "hitchhiker" => "HHGG"
    };

module Conf {
    var dailyQuote = false;
    var CONF = {};
    var lastQuote = null;
    var lastQuoteTimeout = null;

    function loadConf() {
        var app = App.getApp();

        dailyQuote = app.getProperty("DAILY_QUOTE");
        if (dailyQuote == null) { dailyQuote = false; }

        lastQuote = app.getProperty("LAST_QUOTE");
        lastQuoteTimeout = app.getProperty("LAST_QUOTE_TIMEOUT");

        CONF = app.getProperty("SOURCES");
        if (CONF == null) {
            CONF = {};
        }
        var c = CONF.keys();
        for (var i = 0; i < c.size(); i++) {
            if (SOURCES[c[i]] == null) {
                CONF.remove(c[i]);
            }
        }
        var s = SOURCES.keys();
        for (var i = 0; i < s.size(); i++) {
            if (CONF[s[i]] == null) {
                CONF[s[i]] = true;
            }
        }

        // TODO
    }

    function saveConf() {
        var app = App.getApp();
        app.setProperty("SOURCES", CONF);
        app.setProperty("DAILY_QUOTE", dailyQuote);
        app.setProperty("LAST_QUOTE", lastQuote);
        app.setProperty("LAST_QUOTE_TIMEOUT", lastQuoteTimeout);
    }
}

class TopView extends UI.View {
    var myNewMessage = null;
    var myLines = ["---"];
    var myTopLine = 0;
    var deviceForm;

    var TAB;

    function initialize() {
        deviceForm = UI.loadResource(Rez.Strings.DeviceForm);
        TAB = UI.loadResource(Rez.Strings.TAB);
        Conf.loadConf();

        if (!Conf.dailyQuote || Conf.lastQuote == null || Conf.lastQuoteTimeout > Sys.getTimer()) {
            update();
        } else {
            setMessage(Conf.lastQuote);
        }
    }

    var font = G.FONT_MEDIUM;
    var L = -1;

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function update() {
        setMessage("Getting a new quote...");
        UI.requestUpdate();

        // Build request
        var url = "http://iheartquotes.com/api/v1/random?format=json&max_characters=1024&width=1024";
        var sources="";
        var s = SOURCES.keys();
        for (var i = 0; i < s.size(); i++) {
            if (Conf.CONF.get(s[i]) == true) {
                sources = sources+"+"+s[i];
            }
        }

        if (sources.length() > 0) {
            url = url+"&source="+sources.substring(1, sources.length());
        }
        Sys.println("URL: "+url);
        Comm.makeJsonRequest(url, null, null, method(:onReceive));
    }

    function onReceive(code, data) {
        if (data == null) {
            setMessage("Cannot get a new quote... Error "+code+".");
            return;
        }
        if (code != 200) {
            Sys.println("onReceive("+code+", "+data+")");
            return;
        }
        var m = data["quote"];
        Sys.println("onReceive("+code+", "+data+") quote.len="+m.length());

        var source = data["source"];

        // Remove special HTML quoting
        m = decodeHTML(m)+"\n["+SOURCES[source]+"]";
        Conf.lastQuote = m;
        var t = Sys.getTimer();
        Conf.lastQuoteTimeout = ((t / (24*60*60)).toNumber()+1)*24*60*60;
        Conf.saveConf();
        setMessage(m);
    }

    function decodeHTML(m) {
        m = BDIT.StringUtils.replace(m, "&quot;", "\"");
        m = BDIT.StringUtils.replace(m, "&lt;", "<");
        m = BDIT.StringUtils.replace(m, "&gt;", ">");
        m = BDIT.StringUtils.replace(m, "&amp;", "&");
        m = BDIT.StringUtils.replace(m, TAB, " ");
        m = BDIT.StringUtils.replace(m, "\r", "");

        return m;
    }

    function setMessage(m) {
        myNewMessage = m;
        UI.requestUpdate();
    }

    function onUpdate(dc) {
        if (myTopLine > myLines.size()-3) { myTopLine = myLines.size()-3; }
        if (myTopLine < 0) { myTopLine = 0; }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var h = dc.getHeight();
        var w = dc.getWidth();
        var y = 0;
        var indent = 0;

        if (deviceForm.equals("round")) {
            indent = w/10;
            y = h/8;
            h = h-2*y;
        }
        if (myNewMessage != null) {
            myLines = BDIT.StringUtils.breakupLines(dc, font, myNewMessage, w-2*indent);
            myNewMessage = null;
        }

        var dy = (1.15*dc.getFontHeight(font)).toNumber();
        var i = myTopLine;
        while (y < h && i < myLines.size()) {
            if (i >= 0) {
                dc.drawText(indent, y, font, myLines[i], G.TEXT_JUSTIFY_LEFT);
            }
            y = y+dy;
            i = i+1;
        }
    }

    function getBehavior() {
        return new ViewInputDelegate(self);
    }

    function move(no) {
        //Sys.println("move("+no+")");
        myTopLine = myTopLine+no;
        UI.requestUpdate();
    }

    function menu() {
        var menu = new BDIT.MenuUtils.Menu({:title => "Quotes"}, method(:onMenuItem));
        menu.addItem(:update, "Update");
        menu.addItem(:sources, "Sources");
        menu.addItem(:dailyQuote, "Daily Quote");
        menu.addItem(:showVersion, "About");

        updateMenu(menu);

        menu.show();
    }

    function updateMenu(menu) {
        menu.setValue(:dailyQuote, Conf.dailyQuote ? "on" : "off");
    }

    function onMenuItem(menu, item) {
        if (item == :update) {
            UI.popView(UI.SLIDE_IMMEDIATE);
            update();
        } else if (item == :dailyQuote) {
            Conf.dailyQuote = !Conf.dailyQuote;
            Conf.saveConf();
        } else if (item == :sources) {
            var sources = new BDIT.MenuUtils.Menu({:title => "Sources"}, method(:onSourceItem));
            sources.addItem(:enableAll, "Enable All");
            sources.addItem(:disableAll, "Disable All");
            // Add sources
            var s = SOURCES.keys();
            for (var i = 0; i < s.size(); i++) {
                sources.addItem(s[i], SOURCES.get(s[i]));
            }

            updateSources(sources);

            sources.show();
        } else if(item == :showVersion) {
            BDIT.Splash.splashUnconditionally();
        }

        updateMenu(menu);
    }

    function onSourceItem(menu, item) {
        if (item == :enableAll || item == :disableAll) {
            var enable = item == :enableAll;
            var c = Conf.CONF.keys();
            for (var i = 0; i < c.size(); i++) {
                Conf.CONF.put(c[i], enable);
            }
        } else {
            var v = Conf.CONF.get(item);
            if (v == null) { v = false; }
            Conf.CONF.put(item, !v);
        }
        Conf.saveConf();
        updateSources(menu);
    }

    function updateSources(sources) {
        var s = Conf.CONF.keys();
        for (var i = 0; i < s.size(); i++) {
            sources.setValue(s[i], Conf.CONF.get(s[i]) ? "on" : "off");
        }
    }
}

// --------------------

//! Behavior for TopView
class ViewInputDelegate extends UI.InputDelegate {
    var view;

    function initialize(view) {
        self.view = view;
    }

    function onKey(evt) {
        var key = evt.getKey();
        //Sys.println("onKey("+key+")");
        if (key == UI.KEY_MENU) {
            view.menu();
            return true;
        }
        if (key == UI.KEY_ENTER) {
            //Sys.println("enter");
            view.move(4);
            return true;
        }
        if (key == UI.KEY_DOWN) {
            //Sys.println("down");
            view.move(4);
            return true;
        }
        if (key == UI.KEY_UP) {
            //Sys.println("up");
            view.move(-4);
            return true;
        }

        return false;
    }

    function onSwipe(evt) {
        var dir = evt.getDirection();
        if (dir == UI.SWIPE_DOWN) {
            view.move(-2);
            return true;
        }
        if (dir == UI.SWIPE_UP) {
            view.move(2);
            return true;
        }
        return false;
    }
}
