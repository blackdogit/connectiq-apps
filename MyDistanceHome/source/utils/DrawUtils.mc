module BDIT {
module DrawUtils {
    using Toybox.System as Sys;
    using Toybox.Math;
    using Toybox.Graphics as G;

    const VERSION = "1.0.0.20150301";

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
            points[i] = [(x+size*arrow[i][0]*Math.sin(heading+arrow[i][1])).toNumber(),
                         (y-size*arrow[i][0]*Math.cos(heading+arrow[i][1])).toNumber()];
            //Sys.println("    "+i+": ["+points[i][0]+";"+points[i][1]+"]");
        }

        dc.setColor(color, G.COLOR_TRANSPARENT);
        dc.fillPolygon(points);
        //Sys.println("<<dA");
    }

}
}
