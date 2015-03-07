module ICNDb {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Communications as Comm;

class TopView extends UI.View {
    var myMessage = "--";

    function onShow() {
        update();
    }

    function onHide() {
    }

    function update() {
        myMessage = "Calling Chuck...";
        UI.requestUpdate();
        Comm.makeJsonRequest("http://api.icndb.com/jokes/random", null, null, method(:icndbCB));
    }

    const L = 30;

    function icndbCB(code, data) {
        //Sys.println("icndbCB(..., "+code+")");
        var m = data["value"]["joke"];

        // Remove special HTML quoting
        m = decodeHTML(m);
        myMessage = breakupLine(m);

        UI.requestUpdate();
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

    // Divide the long line into smaller lines with max 30 characters per line...
    function breakupLine(m) {
        var res = "";
        var last = 0;
        while (m != null && m.length() > 0) {
            var n = m.find(" ");
            if (n == null) {
                n = m.length();
            } else {
                n = n+1;
            }
            if (last > 0 && last+n > L) {
                res = res+"\n";
                last = 0;
            }
            res = res+m.substring(0, n);
            last = last+n;
            if (n == m.length()) {
                m = null;
            } else {
                m = m.substring(n, m.length());
            }
        }
        return res;
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            Graphics.FONT_SMALL, myMessage,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
}