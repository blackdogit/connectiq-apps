using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Math;

//using BDIT.DrawUtils as DU;

class Circle2Layout {
    const ticks = 12;
    function draw(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();

        // Calculate the transformation matrix
        var size = w;
        if (h < w) { size = h; }
        size = .3*size;

        var x0 = (w/2).toNumber();
        var y0 = (h/2).toNumber();
        var angle = Math.PI*2/ticks;

        // Now draw
        dc.setPenWidth(2);
        dc.setColor(State.fg, State.bg);
        for (var i = 0; i < ticks; i = i+1) {
            var m = new BDIT.DrawUtils.TM2D();
            m.rotate(angle*i).scale(size);
            var pn = m.t(0, 1);
            var pe = m.t(0, 1.2);

            dc.drawLine(pn[0]+x0, pn[1]+y0, pe[0]+x0, pe[1]+y0);
        }
        BDIT.DrawUtils.drawArc(dc, x0, y0, size, null, null, State.fg, 3);

        BDIT.DrawUtils.drawArrow(dc, State.currentHeading, size*.9, G.COLOR_GREEN, x0, y0);
        dc.setColor(State.fg, G.COLOR_TRANSPARENT);
        dc.drawText(x0, y0, G.FONT_LARGE, State.currentHeadingDeg+"°", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);

        dc.drawText(x0-1, y0-1.4*size, G.FONT_SMALL, "0", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
        dc.drawText(x0+1.3*size, y0, G.FONT_SMALL, "90", G.TEXT_JUSTIFY_LEFT|G.TEXT_JUSTIFY_VCENTER);
        dc.drawText(x0, y0+1.4*size, G.FONT_SMALL, "180", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
        dc.drawText(x0-1.2*size, y0, G.FONT_SMALL, "270", G.TEXT_JUSTIFY_RIGHT|G.TEXT_JUSTIFY_VCENTER);
    }
}