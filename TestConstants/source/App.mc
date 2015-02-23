using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class TestConstantsApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new TestConstantsView(), new TestConstantsDelegate() ];
    }

}

class TestConstantsDelegate extends Ui.BehaviorDelegate {

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new TestConstantsMenuDelegate(), Ui.SLIDE_UP);
    }

}