using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Math;

class PointLayout {
    var HEADING_N = "N";
    var HEADING_NE = "NE";
    var HEADING_E = "E";
    var HEADING_SE = "SE";
    var HEADING_S = "S";
    var HEADING_SW = "SW";
    var HEADING_W = "W";
    var HEADING_NW = "NW";

    function draw(dc) {
        var txt = "--";
        var deg = (State.currentHeading/Math.PI*180).toNumber();
        if (deg < 0) { deg = deg+360; }

        if (deg <= 22.5) {
            txt = HEADING_N;
        } else if (deg < 67.5) {
            txt = HEADING_NE;
        } else if (deg <= 112.5) {
            txt = HEADING_E;
        } else if (deg < 157.5) {
            txt = HEADING_SE;
        } else if (deg <= 202.5) {
            txt = HEADING_S;
        } else if (deg < 247.5) {
            txt = HEADING_SW;
        } else if (deg <= 292.5) {
            txt = HEADING_W;
        } else if (deg < 337.5) {
            txt = HEADING_NW;
        } else {
            txt = HEADING_N;
        }

        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, G.FONT_LARGE, txt, G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
    }
}