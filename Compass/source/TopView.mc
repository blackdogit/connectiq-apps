using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Communications as Comm;
using Toybox.Sensor;
using Toybox.Math;

module State {
    // Heading according to GPS
    var currentGPSHeading = null;
    var currentGPSAccuracy = Pos.QUALITY_NOT_AVAILABLE;

    // Heading according to sensor
    var currentSensorHeading = null;

    // Heading according to sensor or GPS
    var currentHeading = 0;
    // Heading according to sensor or GPS (in Deg)
    var currentHeadingDeg = 0;
    var currentAccuracy = Pos.QUALITY_NOT_AVAILABLE;

    var useGPS = true;
    var useSensor = true;

    var fg = G.COLOR_BLACK;
    var bg = G.COLOR_WHITE;

    var font = G.FONT_MEDIUM;

    //! +1 to all Pos.QUALITY_*
    const QUALITY_SENSOR = 5;
}

class TopView extends UI.View {
    var deviceForm;

    function initialize() {
        var app = App.getApp();
        var v = app.getProperty("layoutNo");
        if (v != null) {
            layoutNo = v.toNumber();
        }
        v = app.getProperty("useSensor");
        if (v != null) {
            State.useSensor = v;
        }
        v = app.getProperty("useGPS");
        if (v != null) {
            State.useGPS = v;
        }

        Pos.enableLocationEvents(Pos.LOCATION_CONTINUOUS, method(:onLocation));

        //Sensor.setEnabledSensors([])
        Sensor.enableSensorEvents(method(:onSensor));
    }

    var layouts = [ new Circle2Layout(), new Circle1Layout(), new DegLayout(), new SimpleArrowLayout(), new Rose1Layout(), new Rose2Layout(), new PointLayout() ];
    var layoutNo = 0;

    var L = -1;

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
        var app = App.getApp();
        app.setProperty("layoutNo", layoutNo);
        app.setProperty("useSensor", State.useSensor);
        app.setProperty("useGPS", State.useGPS);
    }

    //! @param info [Pos.Info]
    function onLocation(info) {
        if (info.heading == null) {
            return;
        }
        State.currentGPSAccuracy = info.accuracy;
        State.currentGPSHeading = info.heading;
        //Sys.println(Sys.getTimer()+": GPS heading="+State.currentGPSHeading);

        UI.requestUpdate();
    }

    //! @param info [Sensor.Info]
    function onSensor(info) {
        State.currentSensorHeading = null;
        if (info.heading != null) {
            State.currentSensorHeading = info.heading;
        }
        //Sys.println(Sys.getTimer()+": sensor heading="+State.currentSensorHeading);

        UI.requestUpdate();
    }

    function onUpdate(dc) {
        // Normalize the layout
        var s = layouts.size();
        if (layoutNo < 0) { layoutNo = layoutNo+s; }
        if (layoutNo >= s) { layoutNo = layoutNo-s; }

        //State.currentSensorHeading = 65.0/180*Math.PI;
        // Prefer sensor (magnetic compass) over GPS
        //Sys.println("use GPS="+State.useGPS+" sensor="+State.useSensor);
        if (State.useSensor && State.currentSensorHeading != null) {
            State.currentHeading = State.currentSensorHeading;
            State.currentAccuracy = State.QUALITY_SENSOR;
        } else if (State.useGPS && State.currentGPSHeading != null) {
            State.currentHeading = State.currentGPSHeading;
            State.currentAccuracy = State.currentGPSAccuracy;
        } else {
            State.currentHeading = null;
        }

        dc.setColor(State.fg, State.bg);
        dc.clear();

        if (State.currentHeading == null) {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, G.FONT_MEDIUM, "-- no heading --", G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
            return;
        }

        // Normalize the readings [0; 2pi[
        if (State.currentHeading < 0) { State.currentHeading = State.currentHeading+2*Math.PI; }
        State.currentHeadingDeg = (State.currentHeading/Math.PI*180).toNumber();

        //Sys.println("no="+layoutNo);
        var l = layouts[layoutNo];

        DrawUtils.drawGPSQuality(dc);

        l.draw(dc);
    }

    function getBehavior() {
        return new ViewInputDelegate(self);
    }

    function changeLayout(delta) {
        layoutNo = layoutNo+delta;
        UI.requestUpdate();
    }

    function menu() {
        var menu = new BDIT.MenuUtils.Menu({:title => "Compass"}, method(:onMenuItem));
        menu.addItem(:useSensor, "Use Sensor", null);
        menu.addItem(:useGPS, "Use GPS", null);
        menu.addItem(:showVersion, "About", null);

        updateMenu(menu);
        menu.show();
    }

    function updateMenu(menu) {
        menu.setValue(:useGPS, State.useGPS ? "on" : "off");
        menu.setValue(:useSensor, State.useSensor ? "on" : "off");

        //Sys.println("uM GPS="+State.useGPS+" sensor="+State.useSensor);
    }

    function onMenuItem(menu, item) {
        if(item == :useGPS) {
            if (State.useGPS) {
                State.useGPS = false;
                State.useSensor = true;
            } else {
                State.useGPS = true;
            }
            updateMenu(menu);
        } else if(item == :useSensor) {
            if (State.useSensor) {
                State.useSensor = false;
                State.useGPS = true;
            } else {
                State.useSensor = true;
            }
            updateMenu(menu);
        } else if(item == :showVersion) {
            BDIT.Splash.splashUnconditionally();
        }
    }
}

// --------------------

//! Behavior for TopView
class ViewInputDelegate extends UI.InputDelegate {
    var view;

    function initialize(view) {
        self.view = view;
    }

    function onKey(evt) {
        var key = evt.getKey();
        //Sys.println("onKey("+key+")");
        if (key == UI.KEY_MENU) {
            view.menu();
            return true;
        }
        if (key == UI.KEY_ENTER) {
            //Sys.println("enter");
            view.changeLayout(1);
            return true;
        }
        if (key == UI.KEY_DOWN) {
            //Sys.println("down");
            view.changeLayout(1);
            return true;
        }
        if (key == UI.KEY_UP) {
            //Sys.println("up");
            view.changeLayout(-1);
            return true;
        }

        return false;
    }

    function onSwipe(evt) {
        var dir = evt.getDirection();
        if (dir == UI.SWIPE_DOWN) {
            view.changeLayout(-1);
            return true;
        }
        if (dir == UI.SWIPE_UP) {
            view.changeLayout(1);
            return true;
        }
        return false;
    }
}
