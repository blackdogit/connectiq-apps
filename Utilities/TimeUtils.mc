using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

module BDIT {
module TimeUtils {
    const VERSION = "20150328";

    //! Formats the specified time value as "hh:mm:ss".
    function formatTime(val) {
        if (val == null) { return "NULL"; }
        var seconds = val%60;
        val = val/60;
        var minutes = val%60;
        var hours = val/60;
        return Lang.format("$1$:$2$:$3$", [hours.format("%02d"),minutes.format("%02d"),seconds.format("%02d")]);
    }
}
}