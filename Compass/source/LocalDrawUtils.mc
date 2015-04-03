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
        if (gpsQualityImages[State.currentAccuracy] == null) {
            if (State.currentAccuracy == Pos.QUALITY_NOT_AVAILABLE) {
                gpsQualityImages[State.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_NOT_AVAILABLE);
            } else if (State.currentAccuracy == Pos.QUALITY_LAST_KNOWN) {
                gpsQualityImages[State.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_LAST_KNOWN);
            } else if (State.currentAccuracy == Pos.QUALITY_POOR) {
                gpsQualityImages[State.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_POOR);
            } else if (State.currentAccuracy == Pos.QUALITY_USABLE) {
                gpsQualityImages[State.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_USABLE);
            } else if (State.currentAccuracy == Pos.QUALITY_GOOD) {
                gpsQualityImages[State.currentAccuracy] = UI.loadResource(Rez.Drawables.QUALITY_GOOD);
            }
        }

        // TODO round
        dc.drawBitmap(dc.getWidth()-16, 0, gpsQualityImages[State.currentAccuracy]);
    }
}