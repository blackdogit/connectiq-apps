using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Communications as Comm;

class TopView extends UI.View {
    var myNewMessage = null;
    var myLines = ["---"];
    var myTopLine = 0;
    var deviceForm;

    function initialize() {
        deviceForm = UI.loadResource(Rez.Strings.DeviceForm);
        update();
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
        setMessage("Calling Chuck...");
        UI.requestUpdate();
        Comm.makeJsonRequest("http://api.icndb.com/jokes/random", null, null, method(:icndbCB));
    }

    function icndbCB(code, data) {
        if (data == null) {
            setMessage("Cannot call Norris... His says error "+code+".");
            return;
        }
        if (code != 200) {
            Sys.println("icndbCB("+code+", "+data+")");
        }
        var m = data["value"]["joke"];

        // Remove special HTML quoting
        setMessage(decodeHTML(m));
    }

    function decodeHTML(m) {
        m = replace(m, "&quot;", "\"");
        m = replace(m, "&lt;", "<");
        m = replace(m, "&gt;", ">");
        m = replace(m, "&amp;", "&");

        return m;
    }

    function replace(m, from, to) {
        var res = "";
        while (m != null && m.length() > 0) {
            var n = m.find(from);
            if (n == null) {
                res = res+m;
                m = null;
            } else {
                res = res+m.substring(0, n)+to;
                m = m.substring(n+from.length(), m.length()-from.length());
            }
        }
        return res;
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

        var dy = (1.25*dc.getFontHeight(font)).toNumber();
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
        var menu = new UI.Menu();
        menu.setTitle("ICNDb");
        menu.addItem("Update", :update);
        menu.addItem("About", :showVersion);
        UI.pushView(menu, new BDIT.UIUtils.CommonMenuInput(method(:onMenuItem)), SLIDE_IMMEDIATE);
    }

    function onMenuItem(item) {
        if(item == :update) {
            update();
        } else if(item == :showVersion) {
            BDIT.Splash.splashUnconditionally();
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
