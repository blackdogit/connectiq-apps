using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;

class App extends App.AppBase {
    function onStart() {
        Sys.println("VERSION: "+UI.loadResource(Rez.Strings.Version));
        clearProperties();
    }

    function onStop() {
    }

    function getInitialView() {
        var view = new TopView();
        return BDIT.Splash.splashIfNeeded(view, view.getBehavior());
    }
}