module BDIT {
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Application as App;
using Toybox.Timer as Timer;

const SPLASH_TIMEOUT = 3000;

//! Simple SplashScreen
//!
//! TODO:
//! - sun image below "My Weather"
//! - version number
class SplashScreen extends UI.View {
    hidden var myMainView;
    hidden var myMainDelegate;

    function initialize(mainView, mainDelegate) {
        myMainView = mainView;
        myMainDelegate = mainDelegate;
        if (App.getApp().getProperty("splashShown") != null) {
            toView();
            return;
        }
        App.getApp().setProperty("splashShown", "yes");

        var timer = new Timer.Timer();

        timer.start(method(:toView), SPLASH_TIMEOUT, false);
    }

    hidden var logo;

    function onLayout(dc) {
        logo = UI.loadResource(Rez.Drawables.Logo32x32);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawBitmap(0, dc.getHeight()-logo.getHeight(), logo);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2-dc.getFontHeight(Graphics.FONT_LARGE)/2,
            Graphics.FONT_LARGE, UI.loadResource(Rez.Strings.AppName),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2+20, dc.getHeight()/2+dc.getFontHeight(Graphics.FONT_LARGE)/2,
            Graphics.FONT_MEDIUM, UI.loadResource(Rez.Strings.Version),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()-10, dc.getHeight()-dc.getFontHeight(Graphics.FONT_SMALL),
            Graphics.FONT_SMALL, "by Black Dog IT",
            Graphics.TEXT_JUSTIFY_RIGHT);
    }

    function toView() {
        UI.switchToView(myMainView, myMainDelegate, UI.SLIDE_UP);
    }
}
}