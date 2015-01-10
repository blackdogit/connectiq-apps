module MyFuelAdvisor {
using Toybox.Application as App;

module Conf {
    //! The nutrition plan.
    //! Consists of items with the distance between each nutrition point (always in km).
    //! Last item repeated until end of run.
    //! Thus [5] means every 5 km;
    //! and [8, 6, 6, 4] means at
    //! 8, 14, 20, 24 ,28, 32, ... km
    //!
    //! From the configuration.
    var plan = [5];

    const FACTOR = 100.0;
    const LEAD_DIST = 50;
}

class Application extends App.AppBase {
    function initialize() {
        Toybox.System.println("init");
    }

    function onStart() {
        // NOP
    }

    function onStop() {
        // NOP
    }

    function getInitialView() {
        Toybox.System.println("gIV");
        return 9; //[ new DataField() ];
    }
}
}