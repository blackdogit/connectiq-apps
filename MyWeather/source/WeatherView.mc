using Toybox.Communications as Comm;
using Toybox.WatchUi as UI;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Position;

//! Simple Weather View
class WeatherView extends UI.View {
    hidden var myWhen;
    function initialize(when) {
        myWhen = when;
    }

    //! The last weather reported
    hidden var myWeather;

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        if (myWeather.city != null) {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM,
                myWeather.city, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function onWeather(weatherNow, Weather3h) {
        myWeather = weatherNow;

        UI.requestUpdate();
    }
}