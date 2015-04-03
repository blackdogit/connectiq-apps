using Toybox.System as Sys;
using Toybox.Math;
using Toybox.Graphics as G;

module BDIT {
module DrawUtils {
    const VERSION = "20150403";

    //! Definition of an arrow.
    //! Array with the point of the arrow, where each point is expressed as
    //! [radius, angle(radians)]
    hidden var arrow = null;

    //! Draws an arrow that points in the specied direction
    function drawArrow(dc, heading, size, color, x, y) {
        if (arrow == null) {
            arrow = [[1.0, 0.0], [0.8, Math.PI.toFloat()*0.8], [0.4, Math.PI.toFloat()], [0.8, -Math.PI.toFloat()*0.8]];
        }
        //Sys.println("drawArrow(dc, "+heading+", "+size+", "+x+", "+y+")");
        var points = new[arrow.size()];

        for (var i = 0; i < arrow.size(); i++) {
            var angle = heading+arrow[i][1];
            var mult = size*arrow[i][0];
            points[i] = [(x+mult*Math.sin(angle)).toNumber(),
                         (y-mult*Math.cos(angle)).toNumber()];
            //Sys.println("    "+i+": ["+points[i][0]+";"+points[i][1]+"]");
        }

        dc.setColor(color, G.COLOR_TRANSPARENT);
        dc.fillPolygon(points);
        //Sys.println("<<dA");
    }

    //! Fast (but kind of bad-looking) arc drawing.
    //! From http://stackoverflow.com/questions/8887686/arc-subdivision-algorithm/8889666#8889666
    //! TODO: Once we have drawArc, use that instead.
    //! Based on https://github.com/CodyJung/connectiq-apps/blob/master/ArcWatch/source/ArcWatchView.mc
    function drawArc(dc, x, y, radius, from, to, color, width) {
        // Defaults:
        if (from == null) { from = 0; }
        if (to == null) { to = 2*Math.PI; }
        if (color == null) { color = G.COLOR_BLACK; }
        if (width == null) { width = 3; }

        dc.setColor(color, G.COLOR_TRANSPARENT);

        var iters = 300*((to-from)/(2*Math.PI))+1;
        var dx = radius*Math.cos(from);
        var dy = -radius*Math.sin(from);

        var m = new BDIT.DrawUtils.TM2D();
        m.rotate(-(to-from)/(iters-1));

        for(var i=0; i < iters; ++i) {
            dc.fillCircle(x + dx, y + dy, width);
            var d = m.t(dx, dy);
            dx = d[0];
            dy = d[1];
        }
    }

    //! 2-d transformation matrix
    //! Calculations are in float as double results in an OOM after a while
    class TM2D {
        var m11 = 1.0;
        var m12 = 0;
        var m21 = 0;
        var m22 = 1.0;

        //! Returns a new matrix for a ratation
        //! @param [Number] angle Angle in radians
        function rotate(angle) {
            //Sys.println("m.rotate("+angle+")");
            var c = Math.cos(angle);
            var s = Math.sin(angle);

            imult(c, s, -s, c);
            //print();

            return self;
        }

        // scale
        function scale(size) {
            //Sys.println("m.scale("+size+")");
            imult(size, 0, 0, size);

            return self;
        }

        // scale
        function scalexy(sizex, sizey) {
            imult(sizex, 0, 0, sizey);

            return self;
        }

        // Mirror in y=x
        function mirrorxy() {
            //Sys.println("m.mirrorxy()");
            imult(0, 1, -1, 0);

            return self;
        }

        // Mirror in y = 0
        function mirrory0() {
            //Sys.println("m.mirrory0()");
            imult(1, 0, 0, -1);

            return self;
        }

        //! Transform x,y
        function t(x, y) {
            return [m11*x+m12*y, m21*x+m22*y];
        }

        //! Transform x,y to pixel value (common case
        function tpixel(x, y) {
            return [(m11*x+m12*y).toNumber(), (m21*x+m22*y).toNumber()];
        }

        //! Destructive multiply
        function mult(m) {
            imult(m.m11, m.m12, m.m21, m.m22);
        }

        //! Destructive multiply
        hidden function imult(n11, n12, n21, n22) {
            var a11 = m11*n11+m12*n21;
            var a12 = m11*n12+m12*n22;
            var a21 = m21*n11+m22*n21;
            var a22 = m21*n12+m22*n22;

            m11 = a11;
            m12 = a12;
            m21 = a21;
            m22 = a22;
        }

        function print() {
            Sys.println(""+m11+"   "+m12);
            Sys.println(""+m21+"   "+m22);
            Sys.println("("+(m11 instanceof Double)+" "+(m12 instanceof Double)+" "+(m21 instanceof Double)+" "+(m22 instanceof Double)+")");
        }
    }
}
}
