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


    var menu = null;
    function configure() {
        Sys.println("Conf.configure()");
        menu = new Gui.Menu();
        menu.setTitle("Settings");
        menu.addItem("Repeat", :toggleRepeat);
        menu.setValue(:toggleRepeat, REPEAT ? "on" : "off");

        UI.pushView(menu, new ConfBehavior(self, menu), UI.SLIDE_LEFT);
    }

    function onMenuItem(item) {
        Sys.println("Conf.onMenuItem()");
        if (item == :toggleRepeat) {
            REPEAT = !REPEAT;
            menu.setValue(:toggleRepeat, REPEAT ? "on" : "off");
        }
    }

    function onAppStart() {
        var app = App.getApp();
        var v;
        v = app.getProperty("REPEAT");
        Sys.println("REPEAT: v="+v);
        if (v != null) {
            REPEAT = v;
        }
        v = app.getProperty("TIMES");
        Sys.println("TIMES: v="+v);
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

class ConfBehavior extends Gui.MenuInputDelegate {
    var myView;
    function initialize(view, menu) {
        MenuInputDelegate.initialize(menu);
        myView = view;
    }
    function onMenuItem(item) {
        myView.onMenuItem(item);
    }
}