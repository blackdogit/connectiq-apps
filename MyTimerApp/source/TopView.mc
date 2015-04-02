using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class TopView extends UI.View {

    var currentPeriod = 0;

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
        dc.clear();

        var font = G.FONT_NUMBER_MEDIUM;

        // Normalize the currentPeriod
        var s = Conf.TIMES.size();
        if (s == 0) {
            Conf.TIMES = [Conf.DEF_PERIOD];
            s = 1;
        }
        if (currentPeriod < 0) { currentPeriod = currentPeriod+s; }
        if (currentPeriod >= s) { currentPeriod = currentPeriod-s; }

        var h = dc.getHeight();
        var w = dc.getWidth();
        var y = 0;
        var dy = dc.getFontHeight(font)+5;
        var i = currentPeriod-1;
        while (y < h && i < Conf.TIMES.size()) {
            if (i >= 0) {
                var t = (i+1).toString()+": "+BDIT.TimeUtils.formatTime(Conf.TIMES[i]);
                if (i == currentPeriod) {
                    dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
                } else {
                    dc.setColor(G.COLOR_LT_GRAY, G.COLOR_BLACK);
                }
                dc.drawText(w/2, y, font, t, G.TEXT_JUSTIFY_CENTER);
            }
            y = y+dy;
            i = i+1;
        }
    }

    function onShow() {
    }
    function onHide() {
        Conf.onAppStop();
    }

    function getBehavior() {
        return new TopViewBehavior(self);
    }

    function move(delta) {
        currentPeriod = currentPeriod+delta;
        UI.requestUpdate();
    }

    function editPeriod() {
        var dur = Calendar.duration({:seconds => Conf.TIMES[currentPeriod]});
        var np = new UI.NumberPicker(UI.NUMBER_PICKER_TIME, dur);
        UI.pushView(np, new BDIT.UIUtils.CommonNumberPickerDelegate(method(:onNumberPicked)), UI.SLIDE_IMMEDIATE);
    }

    function start() {
        Conf.onAppStop();
        var v = new RunView();
        UI.pushView(v, v.getBehavior(), UI.SLIDE_LEFT);
    }

    function onNumberPicked(dur) {
        Conf.TIMES[currentPeriod] = dur.value();
        UI.requestUpdate();
    }

    function menu() {
        var menu = new UI.Menu();
        menu.setTitle("Edit Timers");
        menu.addItem("Start", :start);
        menu.addItem("Edit", :edit);
        menu.addItem("Insert", :insert);
        menu.addItem("Add", :add);
        menu.addItem("Delete", :delete);
        menu.addItem("Settings", :settings);
        menu.addItem("About", :about);
        UI.pushView(menu, new BDIT.UIUtils.CommonMenuInput(method(:onMenuItem)), SLIDE_IMMEDIATE);
    }

    function onMenuItem(item) {
        UI.popView(UI.SLIDE_IMMEDIATE);
        if (item == :start) {
            start();
            return;
        } else if (item == :edit) {
            editPeriod();
            return;
        } else if (item == :insert) {
            Conf.TIMES = BDIT.ArrayUtils.arrayAdd(Conf.TIMES, currentPeriod, Conf.DEF_PERIOD);
        } else if (item == :add) {
            Conf.TIMES = BDIT.ArrayUtils.arrayAdd(Conf.TIMES, Conf.TIMES.size(), Conf.DEF_PERIOD);
            currentPeriod = Conf.TIMES.size()-1;
        } else if (item == :delete) {
            Conf.TIMES = BDIT.ArrayUtils.arrayDelete(Conf.TIMES, currentPeriod);
        } else if (item == :settings) {
            //Sys.println(":s$ettings");
            Conf.configure();
            return;
        } else if (item == :about) {
            BDIT.Splash.splashUnconditionally();
            return;
        }
        //Sys.println("TIMES="+Conf.TIMES.toString());
        UI.requestUpdate();
    }
}

class TopViewBehavior extends UI.InputDelegate {
    var myView;
    function initialize(view) {
        myView = view;
    }

    function onKey(evt) {
        var key = evt.getKey();
        //Sys.println("key="+key);
        if (key == UI.KEY_DOWN) {
            myView.move(1);
            return true;
        } else if (key == UI.KEY_UP) {
            myView.move(-1);
            return true;
        } else if (key == UI.KEY_ENTER) {
            myView.start();
            return true;
        } else if (key == UI.KEY_MENU) {
            myView.menu();
            return true;
        }
        return false;
    }
}