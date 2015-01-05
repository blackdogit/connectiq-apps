using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.Position;

//! Description of the weather at a specific point in time:
//! either now or in 3 hours
class Weather {
    //! The current city
    var city;
    //! The temperature (F or C)
    var temperature;
}

class DataModel {
    //! Method to be called to update the view
    //! Called as myUpdater(model)
    hidden var myUpdater;

    var weatherNow = new Weather();
    var weather3h = new Weather();

    //! Constructs and returns a new model
    function initialize() {
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
    }

    //! Updates the updater method called when
    function setViewUpdater(method) {
        myUpdater = method;
        myUpdater.invoke(weatherNow, weather3h);
    }

    //! Converts from kelvin to C or F
    hidden function kelvinToLocal(kelvin) {
        return (kelvin - 273);
    }

    //! Invoked when the position changes
    function onPosition(info) {
        var latLon = info.position.toDegrees();

        Sys.println(latLon[0].toString());
        Sys.println(latLon[1].toString());

        Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",
             {"lat"=>latLon[0].toFloat(), "lon"=>latLon[1].toFloat()}, {}, method(:onReceiveNow));
        Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",
             {"lat"=>latLon[0].toFloat(), "lon"=>latLon[1].toFloat()}, {}, method(:onReceive3h));
    }

    function onReceiveNow(httpCode, data) {
        translateWeatherData(weatherNow, data);
        if (myUpdater != null) {
            myUpdater.invoke(weatherNow, weather3h);
        }
    }

    function onReceive3h(httpCode, data) {
        translateWeatherData(weather3h, data);
        if (myUpdater != null) {
            myUpdater.invoke(weatherNow, weather3h);
        }
    }

    hidden function translateWeatherData(weather, data) {
        weather.city = data["name"];
        weather.temperature = kelvinToLocal(data["main"]["temp"]);
        Sys.println(weather.city);
        Sys.println(weather.temperature);
    }
}