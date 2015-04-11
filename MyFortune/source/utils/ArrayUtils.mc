using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

module BDIT {
module ArrayUtils {
    const VERSION = "20150328";

    //! Returns the array with the specified item deleted.
    function arrayDelete(array, no) {
        var s = array.size();
        if (s == 0) { return array; }
        var n = new [s-1];
        for (var i = 0; i < s-1; i++) {
            n[i] = array[i >= no ? (i+1) : i];
        }

        return n;
    }

    //! Returns the array with the specified item deleted.
    function arrayAdd(array, no, value) {
        var s = array.size();
        var n = new [s+1];
        for (var i = 0; i < s; i++) {
            n[i < no ? i : (i+1)] = array[i];
        }
        n[no] = value;

        return n;
    }
}
}