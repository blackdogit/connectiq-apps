module ManOverboard {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Position as Pos;
using Toybox.Timer;
using Toybox.Time;

//! Module with various utility functions that does not belong anywhere else
module Utils {
    function loc2DegString(loc) {
        var dl = lc.toDegrees();
        var txt = "";
        if (dl[0] > 0) {
            txt = txt+"N "+dl[0].format("%.4f");
        } else {
            txt = txt+"S "+(-dl[0]).format("%.4f");
        }
        if (dl[1] > 0) {
            txt = txt+" W "+dl[1].format("%.4f");
        } else {
            txt = txt+" E "+(-dl[1]).format("%.4f");
        }
        Sys.println("txt="+txt);
        return txt;
    }
}
}