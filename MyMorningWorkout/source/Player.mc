module MyMorningWorkout {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class Player extends UI.View {
    var myWorkout = null;
    var myStepNo;
    var myStep = null;

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

    function initialize(workout) {
        myWorkout = workout;
        myStepNo = 0;
    }

    //! Load your resources here
    function onLayout(dc) {
        endTimer = new Timer.Timer();
        secondTimer = new Timer.Timer();
    }

    //! Starts the timer
    function start() {

    }

    function startStep() {
        myStep = myWorkout.getStep(myStepNo);
        startTime = Time.now().value();

        endTimer.start(:stopStep, myStep.time*1000, false);
        endTimer.start(:onSecond, 1000, true);

        UI.requestUpdate();
    }

    function onSecond() {
        UI.requestUpdate();
    }

    //! Stops the timer
    function stopStep() {
        endTimer.stop();
        startTime = null;
        updateSecondTimer();
        UI.requestUpdate();
    }

    function onNextStepAtt() {
        var ds = Sys.getDeviceSettings();
        Att.backlight(true);
        Sys.println("DS: vibrate="+ds.vibrateOn+" tones="+ds.tonesOn);
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(50, 500)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_STOP);
        }
    }

    function onStopStepAtt() {
        var ds = Sys.getDeviceSettings();
        Att.backlight(true);
        Sys.println("DS: vibrate="+ds.vibrateOn+" tones="+ds.tonesOn);
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(50, 500)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_STOP);
        }
    }

    function onStopWorkoutAtt() {
        var ds = Sys.getDeviceSettings();
        Att.backlight(true);
        Sys.println("DS: vibrate="+ds.vibrateOn+" tones="+ds.tonesOn);
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(50, 500)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_STOP);
        }
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
            Graphics.FONT_TINY, "Workout",
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            Graphics.FONT_NUMBER_HOT, txt,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2+dc.getFontHeight(Graphics.FONT_NUMBER_HOT),
            Graphics.FONT_MEDIUM, myStep.name,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onShow() {
        startWorkout();
    }
    function onHide() {
        stopWorkout();
    }
}

class Behavior extends UI.BehaviorDelegate {
}
}