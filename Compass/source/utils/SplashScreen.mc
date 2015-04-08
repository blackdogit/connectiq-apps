module BDIT {
module Splash {
    using Toybox.WatchUi as UI;
    using Toybox.System as Sys;
    using Toybox.Application as App;
    using Toybox.Timer as Timer;
    using Toybox.Graphics as G;

    const VERSION = "20150407";

    //! The timeout is divided into three parts:
    //! 1) an initial static pause (500 ms) used to allow the system SLIDE_DOWN for widgets
    //! 2) an movement phase (2000 ms) where the texts move
    //! 3) an final static phase (500 ms)
    const PHASE1 = 500;
    const PHASE2 = 2000;
    const PHASE3 = 500;

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
        const ANIMATE = true;
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

        // Animator for the texts (locX: 0.0 -> 1.0)
        hidden var animator = new UI.Drawable({:locX => 0.0});

        var fontLargeHeight;
        var fontSmallHeight;
        var fontTinyHeight;

        function onLayout(dc) {
            appName = UI.loadResource(Rez.Strings.AppName);
            appVersion = "v. "+UI.loadResource(Rez.Strings.Version);
            logo = UI.loadResource(Rez.Drawables.Logo32x32);
            deviceForm = UI.loadResource(Rez.Strings.DeviceForm);

            fontLargeHeight = dc.getFontHeight(G.FONT_LARGE);
            fontSmallHeight = dc.getFontHeight(G.FONT_SMALL);
            fontTinyHeight = dc.getFontHeight(G.FONT_TINY);

            phase1();
        }

        function phase1() {
            Sys.println("phase1()");
            if (ANIMATE) {
                timer = new Timer.Timer();
                timer.start(method(:phase2), PHASE1, false);
            } else {
                phase3();
            }
        }

        function phase2() {
            Sys.println("phase2()");
            timer = null;
            updateAll = false;
            UI.animate(animator, :locX, UI.ANIM_TYPE_LINEAR, 0.0, 1.0, PHASE2/1000.0, method(:phase3));
        }

        function phase3() {
            Sys.println("phase3()");
            updateAll = true;
            animator.locX = 1.0;
            if (myMainView != null) {
                timer = new Timer.Timer();
                timer.start(method(:finish), PHASE1+PHASE2+PHASE3, false);
            }
        }

        //! Whether or not to perform a complete update of the screen
        var updateAll = true;

        function onUpdate(dc) {
            var deltaX = animator.locX; // 0-> 1
            Sys.println(Sys.getTimer()+": deltaX="+deltaX);

            var h = dc.getHeight();
            var w = dc.getWidth();
            var indent = 0;

            if (deviceForm.equals("round")) {
                h = h*0.8;
                indent = 20;
            }

            dc.setColor(G.COLOR_DK_GRAY, G.COLOR_DK_GRAY);
            if (updateAll) {
                dc.clear();
                dc.drawBitmap(indent, h-logo.getHeight(), logo);
            } else {
                dc.fillRectangle(0, h/2-fontLargeHeight, w, fontLargeHeight+fontTinyHeight+4);
            }

            dc.setColor(G.COLOR_WHITE, G.COLOR_DK_GRAY);
            dc.drawText(w/2-30*(1-deltaX), h/2-fontLargeHeight/2,
                G.FONT_LARGE, appName,
                G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);

            dc.setColor(G.COLOR_LT_GRAY, G.COLOR_DK_GRAY);
            dc.drawText(w/2+50-20*deltaX, h/2+fontTinyHeight/2+4,
                G.FONT_TINY, appVersion,
                G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);
            if (updateAll) {
                dc.drawText(w-10-indent, h-fontSmallHeight,
                    G.FONT_SMALL, "by Black Dog IT",
                    G.TEXT_JUSTIFY_RIGHT);
            }
        }

        function finish() {
            Sys.println("finish()");
            if (timer != null) {
                timer.stop();
                timer = null;
            }
            if (myMainView != null) {
                UI.switchToView(myMainView, myMainDelegate, UI.SLIDE_IMMEDIATE);
                myMainView = null;
                myMainDelegate = null;
            } else {
                UI.popView(UI.SLIDE_IMMEDIATE);
            }
        }

        function getBehavior() {
            return new SplashScreenBehavior(method(:finish));
        }
    }

    hidden class SplashScreenBehavior extends UI.InputDelegate {
        var myMethod;
        function initialize(method) {
            myMethod = method;
        }
        function onKey(evt) {
            var key = evt.getKey();
            if (key == UI.KEY_ENTER || key == UI.KEY_ESC) {
                myMethod.invoke();
                return true;
            }
            return false;
        }
    }
}
}