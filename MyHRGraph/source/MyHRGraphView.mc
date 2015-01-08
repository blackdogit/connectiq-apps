using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
//using Toybox.Communications as Comm;

class MyHRGraphView extends Ui.SimpleDataField {

    //hidden var txt = "unknown";

    //! Set the label of the data field here.
    function initialize() {
        Sys.println("Initialized");
        label = "Temperature";
    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and return it in this method.
    //! @param [Activity.Info] ...
    //! @param [String] the current temperature
    function compute(info) {
        //Sys.println("compute");
        //requestWeather(info.currentLocation, info.currentLocationAccuracy);
        return ""; //txt;
    }

    //! Requests the weather for the specified location and updates the txt field
    //! @param [Toybox::Position::Location] the location
    //! @param [Toybox::Position::Info.accuracy] the accuracy of the location
    //! @return void
    //function requestWeather(location, accuracy) {
        //! @type [lat, long]
        //var ll = location.toDegrees();

        //Sys.println("pos: "+ll[0].toString()+" "+ll[1].toString()+" "+" ("+accuracy+")");

        //txt = ll[0].toString()+" "+ll[1].toString();
    //}
}