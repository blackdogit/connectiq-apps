module MyCurrentTasks {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
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
        setLayout(Rez.Layouts.WaitLayout(dc));

        timerTxt = View.findDrawableById("myTime");
        timerIcon = View.findDrawableById("myIcon");
    }

    function onUpdate(dc) {
        timerTxt.setText(txt);

        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onShow() {
        Pos.enableLocationEvents(Pos.LOCATION_ONE_SHOT, method(:onLocation));
    }
    function onHide() {
    }

    function onLocation(posInfo) {
        var ll = posInfo.position.toDegrees();
        var lat = ll[0].toFloat();
        var long = ll[1].toFloat();

        Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",
             {"lat"=>latLon[0].toFloat(), "lon"=>latLon[1].toFloat()}, {}, method(:onReceive));

    }
}
}