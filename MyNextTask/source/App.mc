module MyNextTaskWidget {
using Toybox.Application as App;
using Toybox.System as Sys;

class App extends App.AppBase {
    function onStart() {
        clearProperties();
    }

    function onStop() {
    }

    function getInitialView() {
        var view = new TopView();
        return [ view, new ViewInputDelegate(view) ];
        //return BDIT.Splash.splashIfNeeded(view, new ViewInputDelegate(view));
    }
}
}