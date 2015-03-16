module ManOverboard {
using Toybox.Application as App;
using Toybox.System as Sys;

class App extends App.AppBase {
    function onStart(state) {
        //clearProperties();
        Sys.println("");
        Sys.println("BDIT.Splash.Version="+BDIT.Splash.VERSION);

        NAV.onAppStart(state);
        Conf.onAppStart(state);

        NAV.start();
    }

    function onStop(state) {
        NAV.onAppStop(state);
        Conf.onAppStop(state);
    }

    function getInitialView() {
        var view = PageManager.getPage(PageManager.FIRST);
        //return [ view, new ViewInputDelegate(view) ];
        return BDIT.Splash.splashIfNeeded(view, view.getBehavior());
    }
}
}