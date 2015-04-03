using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Math;

class SimpleArrowLayout {
    function draw(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var size = w;
        if (h < w) { size = h; }

        BDIT.BDIT.DrawUtils.drawArrow(dc, State.currentHeading, size*.4, G.COLOR_GREEN, w/2, h/2);
    }
}