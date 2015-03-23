using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

module Utils {
    //! Formats the specified time value as "hh:mm:ss".
    function formatTime(val) {
        if (val == null) { return "NULL"; }
        var seconds = val%60;
        val = val/60;
        var minutes = val%60;
        var hours = val/60;
        return Lang.format("$1$:$2$:$3$", [hours.format("%02d"),minutes.format("%02d"),seconds.format("%02d")]);
    }

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

    class CommonMenuInput extends UI.MenuInputDelegate {
        var myOnMenuItemMethod;
        function initialize(onMenuItemMethod) {
            myOnMenuItemMethod = onMenuItemMethod;
        }

        function onMenuItem(item) {
            myOnMenuItemMethod.invoke(item);
        }
    }

    class CommonNumberPickerDelegate extends UI.NumberPickerDelegate {
        var myOnNumberPickedMethod;
        function initialize(onNumberPickedMethod) {
            myOnNumberPickedMethod = onNumberPickedMethod;
        }

        function onNumberPicked(value) {
            myOnNumberPickedMethod.invoke(value);
        }
    }
}