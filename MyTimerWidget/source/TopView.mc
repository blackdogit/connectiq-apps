module MyTimerWidget {
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Timer;
using Toybox.Time;

class TopView extends UI.View {
    //! Timer in seconds
    var timerVal = 65;
    //! A one-shot for timerVal*1000
    var endTimer;
    //! 1-second repeating timer
    var secondTimer;
    var secondTimerRunning = false;
    //! Time when timer was started (as returned by Time.now().value())
    //! null if not started
    var startTime = null;

    var timerTxt;

    //! true if this view is shown - false otherwise
    var widgetShown = false;

    //! Load your resources here
    function onLayout(dc) {
        endTimer = new Timer.Timer();
        secondTimer = new Timer.Timer();
        setLayout(Rez.Layouts.MainLayout(dc));

        timerTxt = View.findDrawableById("myTime");
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
        stop();
        Sys.println("onEnd");
    }

    function onUpdate(dc) {
        if (startTime != null) {
            var now = Time.now().value();
            var val = timerVal-(startTime-now);
            timerTxt.setText(timerVal.toString());
        } else {
            timerTxt.setText("---");
        }

        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onShow() {
        widgetShown = true;
        updateSecondTimer();
    }
    function onHide() {
        widgetShown = false;
        updateSecondTimer();
    }

    //! Starts and stops secondTimer as needed
    function updateSecondTimer() {
        var sTWanted = startTime != null && widgetShown;
        if (secondTimerRunning == sTWanted) { return; }
        secondTimerRunning = sTWanted;
        if (secondTimerRunning) {
            secondTimer.start(method(:onTick), 1000, true);
        } else {
            secondTimer.stop();
        }
    }

    function onTick() {
        UI.requestUpdate();
    }
}

class ViewInputDelegate extends UI.BehaviorDelegate {
    var view;

    function initialize(view) {
        self.view = view;
    }

    function onMenu() {
        Sys.println("onMenu");

        view.start();
        return true;
    }
}
}