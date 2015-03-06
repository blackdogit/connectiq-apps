module BDIT {
module Splash {
    using Toybox.WatchUi as UI;
    using Toybox.System as Sys;
    using Toybox.Application as App;
    using Toybox.Timer as Timer;

    const VERSION = "1.0.0.20150305";

    const SPLASH_TIMEOUT = 3000;

//! Show the splash screen if needed.
//!
//! Returns either '[ splash-view, null ]' or '[mainView, mainDelegate]'.
//!
//! @pram mainView
//! @pram mainDelegate
    function splashIfNeeded(mainView, mainDelegate) {
        if (App.getApp().getProperty("splashShown") != null) {
            return [mainView, mainDelegate];
        }
        App.getApp().setProperty("splashShown", "yes");
        return [ new SplashScreen(mainView, mainDelegate) ];
    }

//! Show the splash screen unconditionally
    function splashUnconditionally() {
        UI.pushView(new SplashScreen(null, null), null, UI.SLIDE_DOWN);
    }

//! Simple SplashScreen
//!
//! TODO:
//! - sun image below "My Weather"
//! - version number
    hidden class SplashScreen extends UI.View {
        hidden var myMainView;
        hidden var myMainDelegate;

        //! Initializes the splash screen.
        //!
        //! If the specified view and delegate is null, then the current
        //! view - the splash screen - is just popped...
        //!
        //! @pram mainView
        //! @pram mainDelegate
        function initialize(mainView, mainDelegate) {
            myMainView = mainView;
            myMainDelegate = mainDelegate;
        }

        hidden var logo;

        function onLayout(dc) {
            logo = UI.loadResource(Rez.Drawables.Logo32x32);

            var timer = new Timer.Timer();
            timer.start(method(:toView), SPLASH_TIMEOUT, false);
        }

        function onUpdate(dc) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.clear();

            dc.drawBitmap(0, dc.getHeight()-logo.getHeight(), logo);

            dc.drawText(dc.getWidth()/2, dc.getHeight()/2-dc.getFontHeight(Graphics.FONT_LARGE)/2,
                Graphics.FONT_LARGE, UI.loadResource(Rez.Strings.AppName),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
            dc.drawText(dc.getWidth()/2+30, dc.getHeight()/2+dc.getFontHeight(Graphics.FONT_TINY)/2+4,
                Graphics.FONT_TINY, "v. "+UI.loadResource(Rez.Strings.Version),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(dc.getWidth()-10, dc.getHeight()-dc.getFontHeight(Graphics.FONT_SMALL),
                Graphics.FONT_SMALL, "by Black Dog IT",
                Graphics.TEXT_JUSTIFY_RIGHT);
        }

        function toView() {
            if (myMainView != null) {
                UI.switchToView(myMainView, myMainDelegate, UI.SLIDE_UP);
                myMainView = null;
                myMainDelegate = null;
            } else {
                UI.popView(UI.SLIDE_UP);
            }
        }
    }
}
}