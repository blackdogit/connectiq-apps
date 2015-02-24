module MyTimerWidget {
using Toybox.Application as App;
using Toybox.System as Sys;

class App extends App.AppBase {
    //! onStart() is called on application start up
    function onStart() {
        // TODO: restore timerVal
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        var view = new TopView();
        return [ view, new ViewInputDelegate(view) ];
    }
}
}