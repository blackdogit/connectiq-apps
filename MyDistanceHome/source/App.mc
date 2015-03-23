using Toybox.Application as App;
using Toybox.System as Sys;

//! Whether we are debuggng
const DEBUG = true;

module Conf {
    const VERSION = "20150323";
    var USE_ANGLE = true;
    var USE_ARROW = true;
}

//! The application class for the datafield.
class App extends App.AppBase {
    function onStart() {
    }

    function onStop() {
    }

    function getInitialView() {
        return [ new DataField() ];
    }
}
