module MyDistanceBack {
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Math;

//! Implementation of the data field.
class DataField extends UI.DataField {
    const NO_DATA = "---";

    var dist = 0;
    var heading = 0;
    var currentHeading = 0;

    //! The given info object contains all the current workout
    //! information.
    //! @param [Activity.Info] ...
    function compute(info) {
        //Sys.println("");
        //Sys.println("in compute()");
        var dh = BDIT.DistanceUtils.calcDistHeading(info.startLocation, info.currentLocation);
        dist = dh[0];
        heading = dh[1];
        //dist = 123.5;
        //heading = Math.PI.toFloat()*.2;
        currentHeading = info.currentHeading;

        Sys.println("compute(info): dist="+dist+", heading="+heading+", currentHeading="+currentHeading);
    }

    function onUpdate(dc) {
        //Sys.println("in onUpdate(dc)");

        // Width and height of the data field
        var w = dc.getWidth();
        var h = dc.getHeight();

        // The text to be shown
        var txt = NO_DATA;

        if (dist != null) {
            txt = BDIT.DistanceUtils.distToString(dist);
            if (w > 200) {
                txt = txt+"  "+calcHeading(heading);
            }
        }

        // Center of the data field
        var wc = w/2;
        // (h-tiny.height)/2+tiny.height
        var hc = (h+dc.getFontHeight(G.FONT_TINY))/2;

        // Show array if heading and current heading is given
        if (Conf.USE_ARROW && heading != null && currentHeading != null) {
            dc.setColor(G.COLOR_BLACK, G.COLOR_WHITE);
            dc.clear();
            var size = w;
            if (h < w) { size = h; }
            drawArrow(dc, heading/180*Math.PI-currentHeading, size*.40, wc, hc);
        }

        // Field Label
        dc.setColor(G.COLOR_BLACK, G.COLOR_TRANSPARENT);
        dc.drawText(2, 1, G.FONT_TINY, "Distance to Start", G.TEXT_JUSTIFY_LEFT);
        // The text itself
        var font = pickFont(dc, txt, w-5);
        dc.drawText(wc, hc-dc.getFontHeight(font)/2, font, txt, G.TEXT_JUSTIFY_CENTER);
    }

    var fonts = [G.FONT_SMALL, G.FONT_MEDIUM, G.FONT_LARGE];

    //! Find and return the best font to use for the given string, so the displayed string is as wide as
    //! possible but not wider than maxWidth.
    function pickFont(dc, string, maxWidth) {
        var i = fonts.size() - 1;

        while(i > 0) {
            if(dc.getTextWidthInPixels(string, fonts[i]) <= maxWidth) {
                return fonts[i];
            }
            i -= 1;
        }

        return fonts[0];
    }

    //! Definition of an arrow.
    //! Array with the point of the arrow, where each point is expressed as
    //! [radius, angle(radians)]
    var arrow = [[1.0, 0.0], [0.8, Math.PI.toFloat()*0.8], [0.4, Math.PI.toFloat()], [0.8, -Math.PI.toFloat()*0.8]];

    //! Draws an arrow that points in the specied direction
    function drawArrow(dc, heading, size, x, y) {
        //Sys.println("drawArrow(dc, "+heading+", "+size+", "+x+", "+y+")");
        var points = new[arrow.size()];

        for (var i = 0; i < arrow.size(); i++) {
            points[i] = [(x+size*arrow[i][0]*Math.sin(heading+arrow[i][1])).toNumber(),
                         (y-size*arrow[i][0]*Math.cos(heading+arrow[i][1])).toNumber()];
            //Sys.println("    "+i+": ["+points[i][0]+";"+points[i][1]+"]");
        }

        dc.setColor(G.COLOR_DK_GREEN, G.COLOR_TRANSPARENT);
        dc.fillPolygon(points);
        //Sys.println("<<dA");
    }

    //! Calculates and returns the text for the heading.
    //! @param dlat [Float]: the delta latitude
    //! @param dong [Float]: the delta longitude
    function calcHeading(heading) {
        return heading.toNumber().toString()+"°";
    }
}
}