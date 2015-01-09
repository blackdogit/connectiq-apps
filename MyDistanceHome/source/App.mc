module MyDistanceBack {
using Toybox.Application as App;

//! Whether we are debuggng
const DEBUG = false;

module Conf {
    var USE_ANGLE = true;
    var USE_LETTERS = false;
    var USE_ARROW = false;
}

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