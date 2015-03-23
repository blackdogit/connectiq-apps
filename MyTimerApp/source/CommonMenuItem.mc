using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class CommonMenuInput extends UI.MenuInputDelegate {
    var myOnMenuItemMethod;
    function initialize(onMenuItemMethod) {
        myOnMenuItemMethod = onMenuItemMethod;
    }
    function onMenuItem(item) {
        myOnMenuItemMethod.invoke(item);
    }
}