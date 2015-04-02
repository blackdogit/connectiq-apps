using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;

module Conf {
    //! The default period
    const DEF_PERIOD = 10;

    //! Repeat infinitely
    var REPEAT = false;
    //! Timer values
    var TIMES = [DEF_PERIOD];

    var TONES = null;
    var VIBRATE = null;

    function configure() {
        Sys.println("Conf.configure()");
        var menu = new BDIT.SettingsUtis.SettingsMenu({:title => "Settings"}, method(:onMenuItem));
        menu.setTitle("Settings");
        menu.addItem("Repeat", :toggleRepeat);

        updateMenu(menu);

        menu.show();
    }

    function updateMenu(menu) {
        menu.setValue(:toggleRepeat, REPEAT ? "on" : "off");
    }

    function onMenuItem(menu, symbol) {
        Sys.println("Conf.onMenuItem()");
        if (symbol == :toggleRepeat) {
            REPEAT = !REPEAT;
        }
        updateMenu(menu);
    }

    function onAppStart() {
        var app = App.getApp();
        var v;
        v = app.getProperty("REPEAT");
        if (v != null) {
            REPEAT = v;
        }
        v = app.getProperty("TIMES");
        if (v != null) {
            TIMES = v;
        } else {
            v = app.getProperty("timer");
            if (v != null) {
                TIMES = [v.toNumber()];
            }
        }
        Sys.println("Conf: REPEAT="+REPEAT+", TIMES="+TIMES.toString());
    }

    function onAppStop() {
        var app = App.getApp();
        app.setProperty("REPEAT", REPEAT);
        app.deleteProperty("TIMES");
        app.setProperty("TIMES", TIMES);
    }
}
