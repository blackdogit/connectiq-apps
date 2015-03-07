module MyNextTaskWidget {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class TopView extends UI.View {
    var c = null;
    function initialize() {
        c = new BDIT.GAPI.Client("666019876322-rp6s5hhu00rn2ajt6onvc746d6lmqrle.apps.googleusercontent.com", "https://www.googleapis.com/auth/calendar.readonly");
    }

    var myState = "--";

    function onShow() {
        c.logon(method(:clientLogon));
    }

    function clientLogon(client, state) {
        Sys.println("clientLogon(..., "+state+")");
        myState = state;

        UI.requestUpdate();
    }

    //! Load your resources here
    function onLayout(dc) {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth()/2, 0,
            Graphics.FONT_TINY, "Timer",
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
            Graphics.FONT_MEDIUM, "state: "+myState,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() {
    }
}
}