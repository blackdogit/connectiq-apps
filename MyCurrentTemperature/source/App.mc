module MyCurrentTemperature {
using Toybox.Application as App;

//! The application class for the datafield.
class Application extends App.AppBase {
    function onStart() {
        // NOP
    }

    function onStop() {
        // NOP
    }

    function getInitialView() {
        return [ new DataField() ];
    }
}
}