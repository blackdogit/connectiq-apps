module WhereAmI {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Position as Pos;
using Toybox.Communications as Comm;

class TopView extends UI.View {
    var myMessage = "--";

    function onShow() {
        update();
    }

    function onHide() {
    }

    function message(msg) {
        myMessage = msg;
        UI.requestUpdate();
    }

    function update() {
        message("Locating...");
//        var pos = Pos.getInfo();
//        if (pos.position != null) {
//            locationCB(pos);
//        } else {
            Pos.enableLocationEvents(Pos.LOCATION_ONE_SHOT, method(:locationCB));
//        }
    }

    function locationCB(locInfo) {
        var ll = locInfo.position.toDegrees();
        Sys.println("lat/long: "+ll[0].toFloat()+" "+ll[1].toFloat());
        var req = {
            "format" => "json",
            "lat"=>ll[0].toFloat(),
            "lon"=>ll[1].toFloat(),
            "addressdetails"=>"1",
            "zoom"=>"18"
        };
        message("Requesting address...");
        Comm.makeJsonRequest("http://nominatim.openstreetmap.org/reverse", req, null, method(:osmCB));
    }

    const L = 30;

    function osmCB(code, data) {
        var m = data["display_name"];
        Sys.println("osmCB(..., "+code+"): m='"+m+"'");

        // Remove special HTML quoting
        m = decodeHTML(m);
        m = breakupLine(m);
        message(m);

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