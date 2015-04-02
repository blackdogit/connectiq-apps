module ManOverboard {
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Position as Pos;
using Toybox.WatchUi as UI;
using Toybox.ActivityRecording;

//! The singlethon data class
var nav;

//! The data manager
module NAV {
    function initialize() {
        nav = self;
    }

    var currentAccuracy = Pos.QUALITY_NOT_AVAILABLE;

    //! The initial start information
    var startPositionInfo;

    //! The current information
    var currentPositionInfo;

    //! The current target location
    //! @type Pos.Location
    var targetLocation;

    //! The radius for the target location in meters
    //! @type float
    var targetRadius;

    //! The current location
    //! @type Pos.Location
    var currentLocation;

    //! The current distance to target.
    //! @type Float
    var currentTargetDist;

    //! The current heading to target.
    //! @type Float
    var currentTargetHeading;

    var session = null;

    hidden var helper = null;

    //! Start the collection of data
    function start() {
        if (Conf.USE_ACTIVITY_SESSION) {
            session = new ActivityRecording.Session({:sport => ActivityRecording.SPORT_GENERIC, :name => "Man Overboard Session"});
            session.start();
        }
        helper = new NAVHelper();
    }

    //! Start the collection of data
    function stop() {
        if (Conf.USE_ACTIVITY_SESSION && session != null) {
            session.stop();
            session.save();
        }
    }

    //! Calculates the best guess for a target location based on the current knowledge
    function calcTargetLocation() {
        //Sys.println("startPositionInfo="+startPositionInfo);
        // TODO: refine the target!
        if (startPositionInfo == null) {
            return;
        }
        targetLocation = startPositionInfo.position;
        //Sys.println("targetLocation="+targetLocation);
    }

    function setCurrentPosition(info) {
        currentPositionInfo = info;
        currentLocation = info.position;

        var dh = BDIT.DistanceUtils.calcDistHeading(targetLocation, currentLocation);
        currentTargetDist = dh[0];
        currentTargetHeading = dh[1];

        UI.requestUpdate();
    }

    //! Restores the state of this module from the given state dictionary
    //! @param state [Dictionary] the state object to read from - can be null
    function onAppStart(state) {
    }
    //! Saves the state of this module to the given state dictionary
    //! @param state [Dictionary] the state object to save from - never null
    function onAppStop(state) {
    }
}

//! Small helper class for NAV - used as method(...) only works in classes
class NAVHelper {
    function initialize() {
        startTime = Time.now().value;
        Pos.enableLocationEvents(Pos.LOCATION_CONTINUOUS, method(:onLocationCB));
    }

    //! @param [Pos.Info]
    function onLocationCB(info) {
        NAV.currentAccuracy = info.accuracy;
        if (NAV.currentAccuracy == Pos.QUALITY_NOT_AVAILABLE) {
            UI.requestUpdate();
            return;
        }

        if (NAV.startPositionInfo == null) {
            NAV.startPositionInfo = info;
            NAV.calcTargetLocation();
        }

        NAV.setCurrentPosition(info);
    }
}
}