module MyDistanceBack {
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Math;

//! The radius of earth in m
const RADIUS_EARTH = 6371000;

//! 2 pi R/2 pi

//! Implementation of the data field.
class DataField extends Ui.SimpleDataField {
    const HEADING_N = Ui.loadResource(Rez.Strings.N);
    const HEADING_NE = Ui.loadResource(Rez.Strings.NE);
    const HEADING_E = Ui.loadResource(Rez.Strings.E);
    const HEADING_SE = Ui.loadResource(Rez.Strings.SE);
    const HEADING_S = Ui.loadResource(Rez.Strings.S);
    const HEADING_SW = Ui.loadResource(Rez.Strings.SW);
    const HEADING_W = Ui.loadResource(Rez.Strings.W);
    const HEADING_NW = Ui.loadResource(Rez.Strings.NW);

    const NO_DATA = "---";

    //! Sets the label of the data field here.
    function initialize() {
        label = Ui.loadResource(Rez.Strings.DataFieldLabel);

        if (DEBUG) {
            Sys.println("Initialized"); // TODO
        }
    }

    //! The given info object contains all the current workout
    //! information.
    //! @param [Activity.Info] ...
    //! @param [String] the current distance and heading in human redable form
    function compute(info) {
        var start = info.startLocation;
        var current = info.currentLocation;
        if (start == null) {
            if (DEBUG) {
                Sys.println("No start location available");
            }
            return NO_DATA;
        }
        if (current == null) {
            if (DEBUG) {
                Sys.println("No current location available");
            }
            return NO_DATA;
        }

        // @type [lat, long]
        var startLL = start.toRadians();
        // @type [lat, long]
        var currentLL = current.toRadians();

        // Vector from current to start
        var dlat = (startLL[0]-currentLL[0]).toFloat();
        var dlong = (startLL[1]-currentLL[1]).toFloat();

        if (DEBUG) {
            Sys.println("* "+startLL[0].toString()+" "+startLL[1].toString()+"  -->  "+currentLL[0].toString()+" "+currentLL[1].toString()+" = "+dlat.toString()+" "+dlong.toString());
        }

        var txt = calcDistance(dlat, dlong)+"  "+calcHeading(dlat, dlong);
        //var txt = calcHeading(dlat, dlong);

        return txt;
    }

    //! Calculates and returns the text for the distance.
    //! @param dlat [Float]: the delta latitude
    //! @param dong [Float]: the delta longitude
    function calcDistance(dlat, dlong) {
        var dist = Math.sqrt(Math.pow(dlat, 2)+Math.pow(dlong, 2))*RADIUS_EARTH;

        if (DEBUG) {
            Sys.println("  = "+dist.toString());
        }

        return BDIT.DistanceUtils.distToString(dist);
    }

    //! Calculates and returns the text for the heading.
    //! @param dlat [Float]: the delta latitude
    //! @param dong [Float]: the delta longitude
    function calcHeading(dlat, dlong) {
        // 0 is north, PI/2 is due east, etc
        var heading = 0;
        // This seems to be necessary to avoid a problem with atan for small values
        if (dlat.abs() < 1e-8 || (dlong/dlat).abs() < 1e-4) {
            if (dlong >= 0) {
                heading = Math.PI/2;
            } else {
                heading = -Math.PI/2;
            }
        } else {
            var d = dlong/dlat;
            heading = Math.atan(d.toFloat());
            if (dlat < 0) {
                heading += Math.PI;
            }
            if (heading < 0) {
                heading += 2.0*Math.PI;
            }
        }
        heading = heading*360.0/(2.0*Math.PI);
        if (DEBUG) {
            Sys.println("  > "+heading.toString());
        }

        var txt = null;

        if (Conf.USE_ANGLE) {
            if (txt != null) {
                txt += "/";
            } else {
                txt = "";
            }
            txt += heading.toLong().toString()+"°";
        }
        if (Conf.USE_LETTERS) {
            if (txt != null) {
                txt += "/";
            } else {
                txt = "";
            }
            if (heading <= 22.5) {
                txt += HEADING_N;
            } else if (heading < 67.5) {
                txt += HEADING_NE;
            } else if (heading <= 112.5) {
                txt += HEADING_E;
            } else if (heading < 157.5) {
                txt += HEADING_SE;
            } else if (heading <= 202.5) {
                txt += HEADING_S;
            } else if (heading < 247.5) {
                txt += HEADING_SW;
            } else if (heading <= 292.5) {
                txt += HEADING_W;
            } else if (heading < 337.5) {
                txt += HEADING_NW;
            } else {
                txt += HEADING_N;
            }
        }
        return txt;
    }
}
}