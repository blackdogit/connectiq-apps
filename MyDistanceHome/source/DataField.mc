module MyDistanceBack {
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Math;

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
    }

    //! The given info object contains all the current workout
    //! information.
    //! @param [Activity.Info] ...
    //! @param [String] the current distance and heading in human redable form
    function compute(info) {
        var dh = BDIT.DistanceUtils.calcDistHeading(info.startLocation, info.currentLocation);
        if (dh[0] == null) {
            return NO_DATA;
        }

        var txt = BDIT.DistanceUtils.distToString(dh[0])+"  "+calcHeading(dh[1]);

        return txt;
    }

    //! Calculates and returns the text for the heading.
    //! @param dlat [Float]: the delta latitude
    //! @param dong [Float]: the delta longitude
    function calcHeading(heading) {
        var txt = null;

        if (Conf.USE_ANGLE) {
            if (txt != null) {
                txt += "/";
            } else {
                txt = "";
            }
            txt += heading.toNumber().toString()+"°";
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