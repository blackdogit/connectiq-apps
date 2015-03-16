module ManOverboard {
using Toybox.Application as App;
using Toybox.System as Sys;

//! TODO use properties
module Conf {
    var USE_ARROW = true;
    var PROXIMITY_ALARM = true;
    var INITIAL_TIME = 30;
    var USE_ACTIVITY_SESSION = true;

    //! Restores the state of this module from the given state dictionary
    //! @param state [Dictionary] the state object to read from - can be null
    function onAppStart(state) {
        var app = App.getApp();
    }
    //! Saves the state of this module to the given state dictionary
    //! @param state [Dictionary] the state object to save from - never null
    function onAppStop(state) {
        var app = App.getApp();
    }
}
}