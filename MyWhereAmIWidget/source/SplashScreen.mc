module BDIT {
module Splash {
    using Toybox.WatchUi as UI;
    using Toybox.System as Sys;
    using Toybox.Application as App;
    using Toybox.Timer as Timer;
    using Toybox.Graphics as G;

    const VERSION = "20150405";

    //! After this time, the splash screen is removed if not shown unconditionally
    const SPLASH_TIMEOUT = 3000;

//! Show the splash screen if needed.
//!
//! Returns either '[ splash-view, null ]' or '[mainView, mainDelegate]'.
//!
//! @pram mainView
//! @pram mainDelegate
    function splashIfNeeded(mainView, mainDelegate) {
        var app = App.getApp();
        var v = app.getProperty("splashShown");
        if (v != null && v.equals(VERSION)) {
            return [mainView, mainDelegate];
        }
        app.setProperty("splashShown", VERSION);
        var ss = new SplashScreen(mainView, mainDelegate);
        return [ ss, ss.getBehavior() ];
    }

    //! Show the splash screen unconditionally
    function splashUnconditionally() {
        var ss = new SplashScreen(null, null);
        UI.pushView(ss, ss.getBehavior(), UI.SLIDE_IMMEDIATE);
    }

//! Simple SplashScreen
    hidden class SplashScreen extends UI.View {
        hidden var myMainView;
        hidden var myMainDelegate;
        hidden var timer;

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

        // Resources
        hidden var logo;
        hidden var appName;
        hidden var appVersion;
        hidden var deviceForm;

        // Animator for the texts (locX: -100 -> 0)
        hidden var animator = new UI.Drawable({:locX => 0});

        function onLayout(dc) {
            appName = UI.loadResource(Rez.Strings.AppName);
            appVersion = UI.loadResource(Rez.Strings.Version);
            logo = UI.loadResource(Rez.Drawables.Logo32x32);
            deviceForm = UI.loadResource(Rez.Strings.DeviceForm);

            if (myMainView != null) {
                timer = new Timer.Timer();
                timer.start(method(:toView), SPLASH_TIMEOUT, false);
            }

            // Animate until 1 sec left
            //UI.animate(animator, :locX, UI.ANIM_TYPE_LINEAR, -100, 0, SPLASH_TIMEOUT/1000.0-1, null);
        }

        function onUpdate(dc) {
            var deltaX = animator.locX;
            Sys.println(Sys.getTimer()+": deltaX="+deltaX);

            var h = dc.getHeight();
            var w = dc.getWidth();
            var indent = 0;

            if (deviceForm.equals("round")) {
                h = h*0.8;
                indent = 20;
            }

            dc.setColor(G.COLOR_DK_GRAY, G.COLOR_DK_GRAY);
            dc.clear();
            dc.drawBitmap(indent, h-logo.getHeight(), logo);

            dc.setColor(G.COLOR_WHITE, G.COLOR_DK_GRAY);
            dc.drawText(w/2+deltaX/2, h/2-dc.getFontHeight(G.FONT_LARGE)/2,
                G.FONT_LARGE, appName,
                G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);

            dc.setColor(G.COLOR_LT_GRAY, G.COLOR_DK_GRAY);
            dc.drawText(w/2+30-deltaX/4, h/2+dc.getFontHeight(G.FONT_TINY)/2+4,
                G.FONT_TINY, "v. "+UI.loadResource(Rez.Strings.Version),
                G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);
            dc.drawText(w-10-indent, h-dc.getFontHeight(G.FONT_SMALL),
                G.FONT_SMALL, "by Black Dog IT",
                G.TEXT_JUSTIFY_RIGHT);
        }

        function toView() {
            if (timer != null) {
                timer.stop();
            }
            if (myMainView != null) {
                UI.switchToView(myMainView, myMainDelegate, UI.SLIDE_IMMEDIATE);
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
                return true;
            }
            return false;
        }
    }
}
}