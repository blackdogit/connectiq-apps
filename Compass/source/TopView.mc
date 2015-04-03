using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Graphics as G;
using Toybox.Position as Pos;
using Toybox.Communications as Comm;
using Toybox.Math;

module State {
    var currentAccuracy = Pos.QUALITY_NOT_AVAILABLE;
    var currentHeading = 0;
    var currentHeadingDeg = 0;

    var fg = G.COLOR_BLACK;
    var bg = G.COLOR_WHITE;

    var font = G.FONT_MEDIUM;
}

class TopView extends UI.View {
    var deviceForm;

    function initialize() {
        Pos.enableLocationEvents(Pos.LOCATION_CONTINUOUS, method(:onLocation));
    }

    var layouts = [ new Circle2Layout(), new Circle1Layout(), new DegLayout(), new SimpleArrowLayout(), new Rose1Layout(), new PointLayout() ];
    var layoutNo = 0;

    var L = -1;

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onLocation(info) {
        State.currentAccuracy = info.accuracy;
        State.currentHeading = -info.heading;
        if (State.currentHeading < 0) { State.currentHeading = State.currentHeading+2*Math.PI; }
        State.currentHeadingDeg = (State.currentHeading/Math.PI*180).toNumber();

        UI.requestUpdate();
    }

    function onUpdate(dc) {
        var s = layouts.size();
        if (layoutNo < 0) { layoutNo = layoutNo+s; }
        if (layoutNo >= s) { layoutNo = layoutNo-s; }

        //Sys.println("no="+layoutNo);
        var l = layouts[layoutNo];

        dc.setColor(State.fg, State.bg);
        dc.clear();

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
        var menu = new UI.Menu();
        menu.setTitle("Compass");
        menu.addItem("Update", :update);
        menu.addItem("About", :showVersion);
        UI.pushView(menu, new BDIT.UIUtils.CommonMenuInput(method(:onMenuItem)), SLIDE_IMMEDIATE);
    }

    function onMenuItem(item) {
        if(item == :update) {
            update();
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
