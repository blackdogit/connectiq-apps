module BDIT {
module DistanceUtils {
using Toybox.System as Sys;
using Toybox.Math;

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