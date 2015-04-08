using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Math;

//using BDIT.DrawUtils as DU;

class Rose2Layout {
    function draw(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();

        // Calculate the transformation matrix
        var size = w;
        if (h < w) { size = h; }
        size = .4*size;

        var m = new BDIT.DrawUtils.TM2D();
        m.rotate(State.currentHeading).scale(size).mirrory0();

        var x0 = (w/2).toNumber();
        var y0 = (h/2).toNumber();

        // Transform the various points of the rose into pixel coordinates
        var ln = m.tpixel(0, 1);
        var le = m.tpixel(1, 0);
        var ls = m.tpixel(0, -1);
        var lw = m.tpixel(-1, 0);

        var pn = m.tpixel(0, .8);
        var pe = m.tpixel(.8, 0);
        var ps = m.tpixel(0, -.8);
        var pw = m.tpixel(-.8, 0);

        var pne = m.tpixel(.2, .2);
        var pse = m.tpixel(.2, -.2);
        var psw = m.tpixel(-.2, -.2);
        var pnw = m.tpixel(-.2, .2);

        // Now draw
        dc.setColor(State.fg, State.bg);
        dc.drawLine(pe[0]+x0, pe[1]+y0, pse[0]+x0, pse[1]+y0);
        dc.fillPolygon([[pe[0]+x0, pe[1]+y0],[pne[0]+x0, pne[1]+y0],[x0, y0]]);

        dc.drawLine(ps[0]+x0, ps[1]+y0, psw[0]+x0, psw[1]+y0);
        dc.fillPolygon([[ps[0]+x0, ps[1]+y0],[pse[0]+x0, pse[1]+y0],[x0, y0]]);

        dc.drawLine(pw[0]+x0, pw[1]+y0, pnw[0]+x0, pnw[1]+y0);
        dc.fillPolygon([[pw[0]+x0, pw[1]+y0],[psw[0]+x0, psw[1]+y0],[x0, y0]]);

        dc.setColor(G.COLOR_DK_RED, State.bg);
        dc.drawLine(pn[0]+x0, pn[1]+y0, pne[0]+x0, pne[1]+y0);
        dc.fillPolygon([[pn[0]+x0, pn[1]+y0],[pnw[0]+x0, pnw[1]+y0],[x0, y0]]);

        dc.setColor(State.fg, State.bg);
        dc.drawText(ln[0]+x0, ln[1]+y0, G.FONT_SMALL, "N", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
        dc.drawText(le[0]+x0, le[1]+y0, G.FONT_SMALL, "E", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
        dc.drawText(ls[0]+x0, ls[1]+y0, G.FONT_SMALL, "S", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
        dc.drawText(lw[0]+x0, lw[1]+y0, G.FONT_SMALL, "W", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
    }
}