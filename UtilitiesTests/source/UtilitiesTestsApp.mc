using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using BDIT.MCUnit;

class UtilitiesTestsApp extends App.AppBase {
    function onStart() {
        testAll();
    }

    function onStop() {
    }

    function getInitialView() {
        return [ new View() ];
    }

    function testAll() {
        try {
            DistUtilsTests.test();
        }
        catch(ex) {
            // Code to handle the throw of AnExceptionClass
        }

        Sys.println("SUCCESS");
    }
}

class View extends UI.View {
}