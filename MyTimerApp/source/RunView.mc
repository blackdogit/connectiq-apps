using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class RunView extends UI.View {
    //! 1-second repeating timer
    var timer;
    //! The current item
    var currentPeriod = 0;

    //! Time when current item will end
    var currentPeriodEnd = 0;

    //! Image used when the tinner is running
    var runningImage;

    function initialize() {
    }

    //! Load your resources here
    function onLayout(dc) {
        timer = new Timer.Timer();

        runningImage = UI.loadResource(Rez.Drawables.Running);
    }

    //! Starts the timer
    function start() {
        //Sys.println("RV.start()");
        timer.start(method(:onTick), 1000, true);
        startPeriod();
    }

    //! Starts a new item
    function startPeriod() {
        //Sys.println("RV.startPeriod()");
        currentPeriodEnd = Time.now().value()+Conf.TIMES[currentPeriod];
        UI.requestUpdate();
    }

    function onTick() {
        UI.requestUpdate();
    }

    //! Stops the timer
    function stop() {
        //Sys.println("RV.stop()");
        timer.stop();
    }

    //! Called when the current item ends
    function onPeriodEnd() {
        longTone();
        currentPeriod = currentPeriod+1;
        var noPeriods = Conf.TIMES.size();
        if (currentPeriod >= noPeriods) {
            if (Conf.REPEAT) {
                currentPeriod = 0;
                startPeriod();
            } else {
                stop();
            }
            return;
        }
        startPeriod();
    }

    function shortTone() {
        Att.backlight(true);
        var ds = Sys.getDeviceSettings();
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(50, 100)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_KEY);
        }
    }

    function longTone() {
        var ds = Sys.getDeviceSettings();
        Att.backlight(true);
        if (ds.vibrateOn) {
            Att.vibrate([new Att.VibeProfile(100, 500)]);
        }
        if (ds.tonesOn) {
            Att.playTone(Att.TONE_TIME_ALERT);
        }
    }

    function onUpdate(dc) {
        //Sys.println("RV.onUpdate()");
        dc.setColor(G.COLOR_LT_GRAY, G.COLOR_BLACK);
        dc.clear();

        // If timer is running, then calculate the time left
        var now = Time.now().value();
        var val = currentPeriodEnd-now;

//        dc.drawBitmap((dc.getWidth()-runningImage.getWidth())/2,
//            (dc.getHeight()/2-dc.getFontHeight(G.FONT_NUMBER_HOT)/2)/2-runningImage.getHeight()/2,
//            runningImage);

        if (val <= 0) {
            onPeriodEnd();
        } else if (val <= 5) {
            // Less than 5 sconds left...
            shortTone();
        }

        var txt = Utils.formatTime(val);

        dc.drawText(dc.getWidth()/2, dc.getHeight()/6,
            G.FONT_TINY, "#"+(currentPeriod+1),
            G.TEXT_JUSTIFY_CENTER);
        dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            G.FONT_NUMBER_HOT, txt,
            G.TEXT_JUSTIFY_CENTER | G.TEXT_JUSTIFY_VCENTER);
    }

    function onShow() {
        start();
    }

    function onHide() {
        stop();
    }

    function getBehavior() {
        return new RunViewBehavior(self);
    }
}

class RunViewBehavior extends UI.InputDelegate {
    var myView;
    function initialize(view) {
        myView = view;
    }

    function onKey(evt) {
        var key = evt.getKey();
        //Sys.println("key="+key);
        if (key == UI.KEY_DOWN) {
            return true;
        } else if (key == UI.KEY_UP) {
            return true;
        } else if (key == UI.KEY_ENTER) {
            myView.stop();
            UI.popView(UI.SLIDE_RIGHT);
            return true;
        } else if (key == UI.KEY_MENU) {
            return true;
        }
        return false;
    }
}