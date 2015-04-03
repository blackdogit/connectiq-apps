using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Math;

class DegLayout {
    function draw(dc) {
        var deg = (State.currentHeading/Math.PI*180).toNumber();

        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, G.FONT_LARGE, deg+"°", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
    }
}