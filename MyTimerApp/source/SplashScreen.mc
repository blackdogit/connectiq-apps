module BDIT {
module Splash {
    using Toybox.WatchUi as UI;
    using Toybox.System as Sys;
    using Toybox.Application as App;
    using Toybox.Timer as Timer;
    using Toybox.Graphics as G;

    const VERSION = "20150323";

    const SPLASH_TIMEOUT = 3000;

//! Show the splash screen if needed.
//!
//! Returns either '[ splash-view, null ]' or '[mainView, mainDelegate]'.
//!
//! @pram mainView
//! @pram mainDelegate
    function splashIfNeeded(mainView, mainDelegate) {
        var v = App.getApp().getProperty("splashShown");
        if (v == VERSION) {
            return [mainView, mainDelegate];
        }
        App.getApp().setProperty("splashShown", VERSION);
        var ss = new SplashScreen(mainView, mainDelegate);
        return [ ss, ss.getBehavior() ];
    }

    //! Show the splash screen unconditionally
    function splashUnconditionally() {
        var ss = new SplashScreen(null, null);
        UI.pushView(ss, ss.getBehavior(), UI.SLIDE_DOWN);
    }

//! Simple SplashScreen
//!
//! TODO:
//! - sun image below "My Weather"
//! - version number
    hidden class SplashScreen extends UI.View {
        hidden var myMainView;
        hidden var myMainDelegate;
        hidden var timer = null;
        hidden var deviceForm;

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
            deviceForm = UI.loadResource(Rez.Strings.DeviceForm);
            Sys.println("deviceForm="+deviceForm);
            if (myMainView != null) {
                timer = new Timer.Timer();
                timer.start(method(:toView), SPLASH_TIMEOUT, false);
            }
        }

        function onUpdate(dc) {
            dc.setColor(G.COLOR_WHITE, G.COLOR_DK_GRAY);
            dc.clear();

            var h = dc.getHeight();
            var indent = 0;

            if (deviceForm.equals("round")) {
                h = h*0.8;
                indent = 20;
            }

            dc.drawBitmap(indent, h-logo.getHeight(), logo);

            dc.drawText(dc.getWidth()/2, h/2-dc.getFontHeight(G.FONT_LARGE)/2,
                G.FONT_LARGE, UI.loadResource(Rez.Strings.AppName),
                G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);

            dc.setColor(G.COLOR_LT_GRAY, G.COLOR_DK_GRAY);
            dc.drawText(dc.getWidth()/2+30, h/2+dc.getFontHeight(G.FONT_TINY)/2+4,
                G.FONT_TINY, "v. "+UI.loadResource(Rez.Strings.Version),
                G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);
            dc.drawText(dc.getWidth()-10-indent, h-dc.getFontHeight(G.FONT_SMALL),
                G.FONT_SMALL, "by Black Dog IT",
                G.TEXT_JUSTIFY_RIGHT);
        }

        function toView() {
            if (timer != null) {
                timer.stop();
            }
            if (myMainView != null) {
                UI.switchToView(myMainView, myMainDelegate, UI.SLIDE_UP);
                myMainView = null;
                myMainDelegate = null;
            } else {
                UI.popView(UI.SLIDE_UP);
            }
        }

        function getBehavior() {
            return new SplashScreenBehavior(method(:toView));
        }
    }

    hidden class SplashScreenBehavior extends UI.InputDelegate {
        var myMethod;
        function initialize(method) {
            myMethod = method;
        }
        function onKey(evt) {
            if (evt.getKey == UI.KEY_ENTER) {
                method.invoke();
            }
        }
    }
}
}