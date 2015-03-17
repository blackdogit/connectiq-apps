module MyWeatherWidget {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Position as Pos;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class View extends UI.View {
    function initialize() {
        var v = App.getApp().getProperty("timer");
        if (v != null) {
            timerVal = v.toNumber();
        }
    }

    //! Load your resources here
    function onLayout(dc) {
    }

    var waitText = "Starting...";
    var jsonNow = null;
    var jsonLater = null;

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        if (waitText != null) {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2,
                Gfx.FONT_MEDIUM, waitText,
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            return;
        }

        Sys.println("City: "+jsonNow["name"]);
        dc.drawText(dc.getWidth()/2, 10,
            Gfx.FONT_TINY, jsonNow["name"],
            Gfx.TEXT_JUSTIFY_CENTER);

    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onShow() {
        setWaitText("Wait for position");
        Pos.enableLocationEvents(Pos.LOCATION_ONE_SHOT, method(:onLocation));
    }
    function onHide() {
    }

    // --------------
    function setWaitText(text) {
        Sys.println("*** WAIT: "+text);
        waitText = text;
        UI.requestUpdate();
    }

    // --------------

    function onLocation(posInfo) {
        var ll = posInfo.position.toDegrees();
        var lat = ll[0].toFloat();
        var long = ll[1].toFloat();

        Sys.println("onLocation: lat/long: "+lat+" "+long);

        setWaitText("Requesting weather");

        Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",
             {"lat"=>lat, "lon"=>long, "units"=>"metric"}, {}, method(:onReceiveNow));
    }

    function onReceiveNow(httpCode, json) {
        Sys.println("onReceive: code: "+httpCode+" "+json.toString());
        if (httpCode != 200) {
            setWaitText("Error requesting data: "+httpCode);
            return;
        }
        jsonNow = json;
        setWaitText(null);
    }
}
}