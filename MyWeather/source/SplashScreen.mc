using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

const SPLASH_TIMEOUT = 2000;

//! Simple SplashScreen
//!
//! TODO:
//! - sun image below "My Weather"
//! - version number
class SplashScreen extends UI.View {
    hidden var myController;
    function initialize(controller) {
        myController = controller;
        var timer = new Timer.Timer();

        timer.start(method(:toView), SPLASH_TIMEOUT, false);
    }

    hidden var logo;

    function onLayout(dc) {
        logo = UI.loadResource(Rez.Drawables.Logo32x32);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

        dc.drawBitmap(0, dc.getHeight()-logo.getHeight(), logo);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            Graphics.FONT_LARGE, "My Weather",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()-10, dc.getHeight()-10,
            Graphics.FONT_SMALL, "by Black Dog IT",
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_RIGHT);
    }

    function toView() {
        myController.toPage(0, UI.SLIDE_UP);
    }
}