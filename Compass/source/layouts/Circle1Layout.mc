using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Math;

//using BDIT.DrawUtils as DU;

class Circle1Layout {
    const ticks = 8;
    function draw(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();

        // Calculate the transformation matrix
        var size = w;
        if (h < w) { size = h; }
        size = .45*size;

        var x0 = (w/2).toNumber();
        var y0 = (h/2).toNumber();
        var angle = Math.PI*2/ticks;

        // Now draw
        dc.setPenWidth(3);
        for (var i = 0; i < ticks; i = i+1) {
            var m = new BDIT.DrawUtils.TM2D();
            m.rotate(-State.currentHeading+angle*i).scale(size).mirrory0();
            var pn = m.t(0, 1);
            var e = .8;
            dc.setColor(State.fg, State.bg);
            if (i == 0) {
                dc.setColor(G.COLOR_RED, State.bg);
                e = .5;
            } else if (i % (ticks/4) == 0) {
                e = .65;
            }
            var pe = m.t(0, e);

            dc.drawLine(pn[0]+x0, pn[1]+y0, pe[0]+x0, pe[1]+y0);
        }
        BDIT.DrawUtils.drawArc(dc, x0, y0, size, null, null, State.fg, 3);

        dc.drawText(x0, y0, G.FONT_MEDIUM, State.currentHeadingDeg+"°", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
    }
}