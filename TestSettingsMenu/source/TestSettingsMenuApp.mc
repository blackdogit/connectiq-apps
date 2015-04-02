using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;

class TestSettingsMenuApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new TestSettingsMenuView(), new TestSettingsMenuDelegate() ];
    }

}

class TestSettingsMenuDelegate extends UI.BehaviorDelegate {
    var REPEAT = true;
    var SIZE = 10;

    function onMenu() {
        Sys.println("onMenu");
        var menu = new BDIT.SettingsUtils.SettingsMenu({:title => "Settings"}, method(:onMenuItem));
        menu.addItem(:toggleRepeat, "Repeat");
        menu.addItem(:setSize, "Size "+SIZE);
        menu.addItem(:about, "About");

        updateMenu(menu);

        menu.show();
        return true;
    }

    function updateMenu(menu) {
        menu.setLabel(:setSize, "Size "+SIZE);
        menu.setValue(:toggleRepeat, REPEAT ? "on" : "off");
    }

    function onMenuItem(menu, symbol) {
        Sys.println("Conf.onMenuItem()");
        if (symbol == :toggleRepeat) {
            REPEAT = !REPEAT;
        } else if (symbol == :setSize) {
            SIZE = (SIZE+1) % 15;
        } else if (symbol == :about) {
            Sys.println("xxx");
        }
        updateMenu(menu);
    }
}