module MyMorningWorkout {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class TopView extends UI.View {
    function initialize() {
        var v = App.getApp().getProperty("workout");
    }

    //! Load your resources here
    function onLayout(dc) {
    }

    //! Starts the workout
    function start() {
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
        Sys.println("DS: vibrate="+ds.vibrateOn+" tones="+ds.tonesOn);
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(50, 500)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_STOP);
        }
        stop();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var val = timerVal;
        if (startTime != null) {
            var now = Time.now().value();
            val = timerVal-(now-startTime);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        }
        var seconds = val%60;
        val = val/60;
        var minutes = val%60;
        var hours = val/60;
        var txt = Lang.format("$1$:$2$:$3$", [hours.format("%02d"),minutes.format("%02d"),seconds.format("%02d")]);

        dc.drawText(dc.getWidth()/2, 0,
            Graphics.FONT_TINY, "Timer",
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            Graphics.FONT_NUMBER_HOT, txt,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
}