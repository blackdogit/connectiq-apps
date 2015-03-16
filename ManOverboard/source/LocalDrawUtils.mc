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
using Toybox.Math;

//! Various drawing utilities used in several of the views
module DrawUtils {
    //! Array with the images for each of the Position.QUALITY_ constants
    var gpsQualityImages = [null, null, null, null, null];
    //! Draws the current GPS accuracy in the top right corner as a small icon
    function drawGPSQuality(dc) {
        if (gpsQualityImages[NAV.currentAccuracy] == null) {
            if (NAV.currentAccuracy== Pos.QUALITY_NOT_AVAILABLE) {
                gpsQualityImages[NAV.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_NOT_AVAILABLE);
            } else if (NAV.currentAccuracy== Pos.QUALITY_LAST_KNOWN) {
                gpsQualityImages[NAV.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_LAST_KNOWN);
            } else if (NAV.currentAccuracy== Pos.QUALITY_POOR) {
                gpsQualityImages[NAV.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_POOR);
            } else if (NAV.currentAccuracy== Pos.QUALITY_USABLE) {
                gpsQualityImages[NAV.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_USABLE);
            } else if (NAV.currentAccuracy== Pos.QUALITY_GOOD) {
                gpsQualityImages[NAV.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_GOOD);
            }
        }
        // TODO use icons
        dc.drawBitmap(dc.getWidth()-16, 0, gpsQualityImages[NAV.currentAccuracy]);
//        dc.drawText(dc.getWidth(), 0,
//            G.FONT_TINY, "GPS: "+NAV.currentAccuracy,
//            G.TEXT_JUSTIFY_RIGHT);
    }

    //! Show arrow if heading and current heading is given
    function drawHeadingArrow(dc) {
        if (Conf.USE_ARROW && NAV.currentTargetHeading != null && NAV.currentPositionInfo.heading != null) {
            var w = dc.getWidth();
            var h = dc.getHeight();
            BDIT.DrawUtils.drawArrow(dc, NAV.currentTargetHeading/180*Math.PI-NAV.currentPositionInfo.heading, h*.40, G.COLOR_DK_GREEN, w/2, h/2);
        }
    }
}
}