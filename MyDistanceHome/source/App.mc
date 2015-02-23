module MyDistanceBack {
using Toybox.Application as App;
using Toybox.System as Sys;

//! Whether we are debuggng
const DEBUG = true;

module Conf {
    const VERSION = "20150223";
    var USE_ANGLE = true;
    var USE_ARROW = true;
}

//! The application class for the datafield.
class Application extends App.AppBase {
    function onStart() {
        Sys.println("MyDistanceBack version "+Conf.VERSION);
        Sys.println("app.onStart: meme="+Sys.getSystemStats().usedMemory+", free="+Sys.getSystemStats().freeMemory+", total="+Sys.getSystemStats().totalMemory);
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