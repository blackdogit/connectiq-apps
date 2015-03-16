module ManOverboard {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

//! Basic Disatnce and Speed View
//!
//!
//!
//!    c1           c2   c3
//!    v             v   v
//! +----------------------------------+
//! |                                  |
//! |  Dist              Heading       | < r1/r1l
//! |             (A)                  |
//! |  Speed                           | < r2/r2l
//! |                                  |
//! +----------------------------------+
//!
class DistSpeedView extends UI.View {
    function initialize() {
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        // Width and height of the data field
        var w = dc.getWidth();
        var h = dc.getHeight();
        //Sys.println("wxh="+w+"x"+h);

        var labelFont = G.FONT_TINY;
        var dataFont = G.FONT_MEDIUM;

        var cw1 = w*.1;
        var cw2 = w/2;
        var cw3 = w*.6;
        //Sys.println("cw1="+cw1+", cw2="+cw2+", cw3="+cw3);

        // Height of one label space
        var rhll = dc.getFontHeight(labelFont)+2;
        var rhld = dc.getFontHeight(dataFont);

        // Height of one label plus data
        var rhl = rhll+rhld;

        // Height of spece between lines
        var rhs = (h-h*.2-2*rhl);

        var rh1l = h*.1;
        var rh1 = rh1l+rhll;
        var rh2l = rh1+rhld+rhs;
        var rh2 = rh2l+rhll;
        //Sys.println("rh1="+rh1l+"/"+rh1+", rh2="+rh2l+"/"+rh2);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        DrawUtils.drawGPSQuality(dc);
        DrawUtils.drawHeadingArrow(dc);

        // Field Labels
        dc.setColor(G.COLOR_DK_GRAY, G.COLOR_TRANSPARENT);
        dc.drawText(cw1, rh1l, labelFont, "Distance", G.TEXT_JUSTIFY_LEFT);
        dc.drawText(cw3, rh1l, labelFont, "Heading", G.TEXT_JUSTIFY_LEFT);
        dc.drawText(cw1, rh2l, labelFont, "Speed", G.TEXT_JUSTIFY_LEFT);

        // The text itself
        dc.setColor(G.COLOR_WHITE, G.COLOR_TRANSPARENT);
        var txt;
        if (NAV.currentTargetDist != null) {
            txt = BDIT.DistanceUtils.distToString(NAV.currentTargetDist);
        } else {
            txt = "---";
        }
        dc.drawText(cw1, rh1, dataFont, txt, G.TEXT_JUSTIFY_LEFT);

        if (NAV.currentTargetHeading != null) {
            txt = NAV.currentTargetHeading.toNumber().toString()+"°";
        } else {
            txt = "---";
        }
        dc.drawText(cw3, rh1, dataFont, txt, G.TEXT_JUSTIFY_LEFT);

        if (NAV.currentPositionInfo != null) {
            // TODO format
            txt = NAV.currentPositionInfo.speed.toString();
        } else {
            txt = "---";
        }
        dc.drawText(cw1, rh2, dataFont, txt, G.TEXT_JUSTIFY_LEFT);
    }

    //! Return the behavior of this view
    function getBehavior() {
        return new DistSpeedBehavior();
    }
}

class DistSpeedBehavior extends UI.BehaviorDelegate {
    function onKey(evt) {
        if (PageManager.onPageKey(evt)) { return true; }
        var key = evt.getKey();
        return false;
    }
}
}