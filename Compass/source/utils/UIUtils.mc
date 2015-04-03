using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

module BDIT {
module UIUtils {
    const VERSION = "20150323";

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
}