using Toybox.System as Sys;
using Toybox.Math;

module BDIT {
module DistanceUtils {
    const VERSION = "1.0.1.20150328";

    var NO_DATA;

    //! The radius of earth in m
    const RADIUS_EARTH = 6371000.0;

    var PIHalf;
    var PITwice;

    //! 2 pi R/2 pi

    //! Calculates and return the distance and heading between two Location object.
    //! Handles the case, where any of the objects are null or designates no location in 920xt or the simulartor.
    //! Returns [null, null] in this case.
    //!
    //! @param [Toybox.Position.Location] start the start location
    //! @param [Toybox.Position.Location] end the end location
    //! @returns [[Float, Float]] the distance (in meters) and the heading (in radians) from start to end
    function calcDistHeading(start, end) {
        if (NO_DATA == null) {
            NO_DATA = [null, null];
            PIHalf = Math.PI/2;
            PITwice = Math.PI*2;
        }
        if (start == null || end == null) {
            return NO_DATA;
        }
        // @type [lat, long]
        var r = start.toRadians();
        var startLat = r[0];
        var startLong = r[1];

        //Sys.println("s="+startLat.toString()+" "+MCUtils.typeof(startLat));
        //Sys.println("pi="+Math.PI.toString()+" "+MCUtils.typeof(Math.PI));
        if ((startLat-Math.PI).abs() < 0.001 && (startLong-Math.PI).abs() < 0.001) {
            return NO_DATA;
        }

        // @type [lat, long]
        r = end.toRadians();
        var endLat = r[0];
        var endLong = r[1];
        r = null;

        // Vector from end to start
        var dlat = startLat-endLat;
        var dlong = startLong-endLong;

        //Sys.println("* "+startLat.toString()+" "+startLong.toString()+"  -->  "+endLat.toString()+" "+endLong.toString()+" = "+dlat.toString()+" "+dlong.toString());

        // Rather expensive, but works!
        var dist = Math.acos(Math.sin(startLat) * Math.sin(endLat) + Math.cos(startLat) * Math.cos(endLat) * Math.cos(endLong-startLong) ) * RADIUS_EARTH;

        // 0 is north, PI/2 is due east, etc
        var heading = 0;
        // This seems to be necessary to avoid a problem with atan for small values
        if (dlat.abs() < 1e-8) {
            if (dlong >= 0) {
                heading = PIHalf;
            } else {
                heading = -PIHalf;
            }
        } else {
            var d = dlong/dlat;
            heading = Math.atan(d);
            if (dlat < 0) {
                heading += Math.PI;
            }
            if (heading < 0) {
                heading += PITwice;
            }
        }
        heading = heading*360.0/PITwice;

        //Sys.println("dist="+dist+" heading="+heading);

        return [dist.toFloat(), heading.toFloat()];
    }

    //! Converts the specified distance to a string
    //! @param dist [Float]: the distance to convert (in meters)
    //! @returns [String]: the converted distance
    function distToString(dist) {
        // Format the distance
        var unit = "m";
        var du = Sys.getDeviceSettings().distanceUnits;
        if (du == Sys.UNIT_METRIC) {
            if (dist > 1000) {
                dist = dist/1000;
                unit = "km";
            }
        } else if (du == Sys.UNIT_STATUTE) {
            if (dist > 1608) {
                dist = dist/1608;
                unit = "mi";
            }
        }

        var txt = null;
        if (dist < 100) {
            txt = dist.format("%.1f");
        } else {
            txt = dist.format("%.0f");
        }
        txt += " "+unit;

        return txt;
    }
}
}
