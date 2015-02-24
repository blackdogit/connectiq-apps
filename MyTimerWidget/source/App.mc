module MyTimerWidget {
using Toybox.Application as App;
using Toybox.System as Sys;

class App extends App.AppBase {
    var timer;
    var view;

    function onStart() {
        timer = getProperty("timer");
        if (timer == null) {
            timer = "60";
        }
    }

    function onStop() {
        if (view != null) {
            setProperty("timer", view.timerVal);
        }
    }

    function getInitialView() {
        view = new TopView();
        view.timerVal = timer.toNumber();
        return [ view, new ViewInputDelegate(view) ];
    }
}
}