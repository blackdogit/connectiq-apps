module WhereAmI {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

//! Behavior for TopView
class ViewInputDelegate extends UI.InputDelegate {
    var view;

    function initialize(view) {
        self.view = view;
    }

    function onKey(evt) {
        var key = evt.getKey();
        //Sys.println("onKey("+key+")");
        if (key != UI.KEY_MENU && key != UI.KEY_ENTER) { return false; }

        var menu = new UI.Menu();
        menu.setTitle("WhereAmI");
        menu.addItem("Update", :update);
        menu.addItem("Show version", :showVersion);
        UI.pushView(menu, new MenuInput(view), SLIDE_IMMEDIATE);

        return true;
    }
}

//! Delegate for the menu
class MenuInput extends UI.MenuInputDelegate {
    var view;

    function initialize(view) {
        self.view = view;
    }

    function onMenuItem(item) {
        if(item == :update) {
            view.update();
        } else if(item == :showVersion) {
            //Sys.println(":showVersion");
            BDIT.Splash.splashUnconditionally();
        }
    }
}
}