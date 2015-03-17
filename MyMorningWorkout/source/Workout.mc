module MyMorningWorkout {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class Workout {
    var name = "7 minute workout";

    hidden var steps = [
        new Step("Push Up", 30, :pushup),
        new Step("Rest", 10, :rest),
        new Step("Jump", 30, :jump)
    ];

    function get(i) {
        return steps[i];
    }
}

class Step {
    var name;
    var time;
    var action;

    function initialize(name, time, action) {
        self.name = name;
        self.time = time;
        self.action = action;
    }
}
}