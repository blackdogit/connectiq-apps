module MyTimerWidget {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
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

    //! true if this view is shown - false otherwise
    var widgetShown = false;

    //! Image used when the tinner is running
    var runningImage;

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

        runningImage = UI.loadResource(Rez.Drawables.Running);
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
        Sys.println("DS: vibrate="+ds.vibrateOn+" tones="+ds.tonesOn);
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(100, 500)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_TIME_ALERT);
        }
        stop();
    }

    function onUpdate(dc) {
        dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
        dc.clear();

        var val = timerVal;
        // If timer is running, then calculate the time left
        if (startTime != null) {
            var now = Time.now().value();
            val = timerVal-(now-startTime);

            dc.drawBitmap((dc.getWidth()-runningImage.getWidth())/2,
                (dc.getHeight()/2-dc.getFontHeight(G.FONT_NUMBER_HOT)/2)/2-runningImage.getHeight()/2,
                runningImage);

            // Less than 5 sconds left...
            if (val <= 5) {
                Att.backlight(true);
                var ds = Sys.getDeviceSettings();
                if (ds.vibrateOn) {
                    Att.vibrate([new Att.VibeProfile(50, 100)]);
                }
                if (ds.tonesOn) {
                    Att.playTone(Att.TONE_KEY);
                }
            }
        }
        var seconds = val%60;
        val = val/60;
        var minutes = val%60;
        var hours = val/60;
        var txt = Lang.format("$1$:$2$:$3$", [hours.format("%02d"),minutes.format("%02d"),seconds.format("%02d")]);

        dc.drawText(0, 0,
            G.FONT_TINY, "Timer",
            G.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            G.FONT_NUMBER_HOT, txt,
            G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);
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