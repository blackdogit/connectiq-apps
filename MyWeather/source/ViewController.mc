using Toybox.Communications as Comm;
using Toybox.WatchUi as UI;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Position;

//! View Controller.
//! Handles all behavior in the application
class ViewController extends UI.BehaviorDelegate {
    var this;
    hidden var myModel;

    hidden var myIndex = 0;
    hidden var PAGES_SIZE = 1;
    hidden var myPages = new [PAGES_SIZE];

    function initialize(model) {
        myModel = model;

        myPages[0] = new WeatherView();
    }

    function toPage(delta, slide) {
        myIndex = (myIndex+delta+PAGES_SIZE) % PAGES_SIZE;
        var v = myPages[myIndex];
        UI.switchToView(v, this, slide);
        myModel.setViewUpdater(v.method(:onWeather));
    }

    function onNextPage() {
        toPage(1, UI.SLIDE_UP);
    }

    function onPreviousPage() {
        toPage(-1, UI.SLIDE_UP);
    }
}
