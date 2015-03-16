module ManOverboard {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Position as Pos;
using Toybox.Timer;
using Toybox.Time;

//! List of target positions over time.
//!
//!
//!
//!    c1           c2   c3
//!    v             v   v
//! +----------------------------------+
//! |                                  |
//! |  Dist              Heading       | < r1/r1l
//! |                                  |
//! |  Speed     (A)                   | < r2/r2l
//! |                                  |
//! |  Target Location                 | < r3/r3l
//! |                                  |
//! +----------------------------------+
//!
class TargetView extends UI.View {
    function initialize() {
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        // Width and height of the data field
        var w = dc.getWidth();
        var h = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        DrawUtils.drawGPSQuality(dc);
        DrawUtils.drawHeadingArrow(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var dl = NAV.targetLocation.toDegrees();
        var txt = "";
        if (dl[0] > 0) {
            txt = txt+"N "+dl[0].format("%.4f");
        } else {
            txt = txt+"S "+(-dl[0]).format("%.4f");
        }
        if (dl[1] > 0) {
            txt = txt+" W "+dl[1].format("%.4f");
        } else {
            txt = txt+" E "+(-dl[1]).format("%.4f");
        }
        Sys.println("txt="+txt);
        //txt="Hello";
        dc.drawText(w/2, h/2, G.FONT_MEDIUM, txt, G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
    }

    //! Return the behavior of this view
    function getBehavior() {
        return new TargetViewBehavior();
    }
}

class TargetViewBehavior extends UI.InputDelegate {
    function onKey(evt) {
        if (PageManager.onPageKey(evt)) { return true; }
        var key = evt.getKey();
        return false;
    }
}
}