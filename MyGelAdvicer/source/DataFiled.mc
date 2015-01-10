module MyNutritionPlan {
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Attention as Att;

class DataField extends Ui.SimpleDataField {
    //! The distance units used
    function initialize() {
        label = Ui.loadResource(Rez.Strings.DataFieldLabel);
    }

    //! The next distance point (in km).
    var nextDistance = -1.0;
    //! The index of the next plan item
    var nextPlanIndex = 0;

    var alerted = false;

    //! Calculate the distance to the next nutrition point
    //! @param info [Activity.Info]: the current activity info
    //! @returns [String]: the distance to the next nutrition point
    function compute(info) {
        var dist = info.elapsedDistance;
        Sys.println("dist="+dist+" next="+nextDistance);
        var du = Sys.getDeviceSettings().distanceUnits;


        // Find the next distance point if needed
        while (dist > nextDistance) {
            var deltaDistance = Conf.plan[nextPlanIndex]*Conf.FACTOR;
            // If 0 is used in the plan array, then default to 1...
            if (deltaDistance == 0) {
                deltaDistance = FACTOR;
            }
            nextPlanIndex++;
            if (nextPlanIndex >= Conf.plan.size()) {
                nextPlanIndex = Conf.plan.size()-1;
            }

            if (du == Sys.UNIT_STATUTE) {
                deltaDistance *= 1.608;
            }
            nextDistance += deltaDistance;
            alerted = false;
        }

        // How far to the next point?
        var delta = nextDistance-dist;
        Sys.println("delta="+delta);

        // If we are less than
        if (delta < Conf.LEAD_DIST) {
            if (!alerted) {
                alerted = true;
                //Att.backlight(true);
                //Att.vibrate(true);
                //Att.playTone(Att.TONE_DISTANCE_ALERT);
            }
            return "Eat Now!";
        }

        // dist is now in the same units as plan...
        var d = BDIT.DistanceUtils.distToString(delta);

        return d;
    }
}
}