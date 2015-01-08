module MyDistanceBack {
using Toybox.Application as App;

//! Whether we are debuggng
const DEBUG = false;

var USE_ANGLE = false;

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