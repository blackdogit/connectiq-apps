module MyTimerWidget {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class TopView extends UI.View {
    //! Timer in seconds
    var timerVal = 60;
    //! A one-shot for timerVal*1000
    var endTimer;
    //! 1-second repeating timer
    var secondTimer;
    var secondTimerRunning = false;
    //! Time when timer was started (as returned by Time.now().value())
    //! null if not started
    var startTime = null;

    //! The Drawable for the icon
    var timerIcon;
    //! The Drawable for the text
    var timerTxt;

    //! true if this view is shown - false otherwise
    var widgetShown = false;

    function initialize() {
        var v = App.getApp().getProperty("timer");
        if (v != null) {
            timerVal = v.toNumber();
        }
    }

    //! Load your resources here
    function onLayout(dc) {
        endTimer = new Timer.Timer();
        secondTimer = new Timer.Timer();
        setLayout(Rez.Layouts.MainLayout(dc));

        timerTxt = View.findDrawableById("myTime");
        timerIcon = View.findDrawableById("myIcon");
    }

    //! Starts the timer
    function start() {
        if (startTime != null) { return; }
        endTimer.start(method(:onEnd), timerVal*1000, false);
        startTime = Time.now().value();
        updateSecondTimer();
        UI.requestUpdate();
    }

    //! Stops the timer
    function stop() {
        if (startTime == null) { return; }
        endTimer.stop();
        startTime = null;
        updateSecondTimer();
        UI.requestUpdate();
    }

    function onEnd() {
        var ds = Sys.getDeviceSettings();
        Att.backlight(true);
        if (ds.vibrateOn) {
            Att.vibrate(true);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_ALARM);
        }
        stop();
        //Sys.println("onEnd");
    }

    function onUpdate(dc) {
        var val = timerVal;
        if (startTime != null) {
            var now = Time.now().value();
            val = timerVal-(now-startTime);
            timerTxt.setColor(Gfx.COLOR_DK_RED);
        } else {
            timerTxt.setColor(Gfx.COLOR_WHITE);
            //timerTxt.setText("---");
        }
        var seconds = val%60;
        val = val/60;
        var minutes = val%60;
        var hours = val/60;
        var txt = Lang.format("$1$:$2$:$3$", [hours.format("%02d"),minutes.format("%02d"),seconds.format("%02d")]);
        timerTxt.setText(txt);

        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onShow() {
        widgetShown = true;
        updateSecondTimer();
    }
    function onHide() {
        App.getApp().setProperty("timer", timerVal);
        widgetShown = false;
        updateSecondTimer();
    }

    //! Starts and stops secondTimer as needed
    function updateSecondTimer() {
        var sTWanted = startTime != null && widgetShown;
        if (secondTimerRunning == sTWanted) { return; }
        secondTimerRunning = sTWanted;
        //Sys.println("updateSecondTimer "+secondTimerRunning);
        if (secondTimerRunning) {
            secondTimer.start(method(:onTick), 1000, true);
        } else {
            secondTimer.stop();
        }
    }

    function onTick() {
        //Sys.println("onTick");

        UI.requestUpdate();
    }
}

//! Behavior for TopView
class ViewInputDelegate extends UI.BehaviorDelegate {
    var view;

    function initialize(view) {
        self.view = view;
    }

    function onMenu() {
        //Sys.println("onMenu");

        var menu = new UI.Menu();
        menu.setTitle("Timer");
        if (view.startTime == null) {
            menu.addItem("Start", :start);
            menu.addItem("Set time", :set);
        } else {
            menu.addItem("Stop!", :stop);
        }
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