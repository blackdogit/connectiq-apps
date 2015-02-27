module MyTimerWidget {
using Toybox.Application as App;
using Toybox.System as Sys;

class App extends App.AppBase {
    function onStart() {
    }

    function onStop() {
    }

    function getInitialView() {
        var view = new TopView();
        return [ view, new ViewInputDelegate(view) ];
    }
}
}