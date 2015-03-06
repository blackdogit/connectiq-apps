module MyTimerWidget {
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
        menu.setTitle(UI.loadResource(Rez.Strings.MenuTitle));
        if (view.startTime == null) {
            menu.addItem(UI.loadResource(Rez.Strings.MenuStart), :start);
            menu.addItem(UI.loadResource(Rez.Strings.MenuSet), :set);
        } else {
            menu.addItem(UI.loadResource(Rez.Strings.MenuStop), :stop);
        }
        menu.addItem(UI.loadResource(Rez.Strings.MenuVersion), :showVersion);
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
        if(item == :start) {
            view.start();
        } else if(item == :stop) {
            view.stop();
        } else if(item == :set) {
            //Sys.println(":set");
            var dur = Calendar.duration({:seconds => view.timerVal});
            var np = new UI.NumberPicker(UI.NUMBER_PICKER_TIME_OF_DAY, dur);
            UI.pushView(np, new SetTimeDelegate(view), UI.SLIDE_IMMEDIATE);
        } else if(item == :showVersion) {
            //Sys.println(":showVersion");
            BDIT.Splash.splashUnconditionally();
        }
    }
}

//! Delegate for the set-time number picker
class SetTimeDelegate extends UI.NumberPickerDelegate {
    var view;

    function initialize(view, np) {
        self.view = view;
    }

    function onNumberPicked(value) {
        view.timerVal = value.value();
        UI.popView(UI.SLIDE_IMMEDIATE);
    }
}

}