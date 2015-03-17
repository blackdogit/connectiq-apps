module MyCurrentTemperature {
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;

const DELAY_BETWEEN_WEATHER_REQUESTS = 5;

class DataField extends Ui.SimpleDataField {
    hidden var txt = "unknown";
    hidden var delayUntilNextRequest = 1;

    //! Set the label of the data field here.
    function initialize() {
        label = "Temperature";
        Sys.println("Initialized"); // TODO
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and return it in this method.
    //! @param [Activity.Info] ...
    //! @param [String] the current temperature
    function compute(info) {
        delayUntilNextRequest--;
        if (delayUntilNextRequest == 0) {
            requestWeather(info.currentLocation, info.currentLocationAccuracy);
        }
        return txt;
    }

    //! Requests the weather for the specified location and updates the txt field
    //! @param [Toybox::Position::Location] the location
    //! @param [Toybox::Position::Info.accuracy] the accuracy of the location
    //! @return void
    function requestWeather(location, accuracy) {
        Sys.println("requestWeather"); // TODO
        if (location == null) {
            txt = "unknown";
            return;
        }
        //! @type [lat, long]
        var ll = location.toDegrees();
        Sys.println("requestWeather 2");

        Sys.println("pos: "+ll[0].toString()+" "+ll[1].toString()+" ("+accuracy+")");

        var requestParameters = {"lat"=>ll[0].toFloat(), "lon"=>ll[1].toFloat()};

        Comm.makeJsonRequest("http://api.openweathermap.org/data/2.5/weather",
             {"lat"=>latLon[0].toFloat(), "lon"=>latLon[1].toFloat()}, {}, method(:onReceive));

        txt = txt+" (req)";
    }

    function onReceive(httpCode, data) {
        Sys.println("httpCode: "+httpCode+" data: "+data);

        delayUntilNextRequest = DELAY_BETWEEN_WEATHER_REQUESTS;
        if (data == null) {
            txt = "unknown (null)";
            return;
        }
        txt = "city: "+data["name"];
    }
}
}