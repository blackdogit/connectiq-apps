module BDIT {
module MCUnit {

    using Toybox.Application as App;
    using Toybox.System as Sys;
    using Toybox.Math;

    function assertTrue(msg, b) {
        if (!b) {
            Sys.println("ASSERT FAILED: "+msg);
            //throw new AssertFailedException(msg);
        }
    }

    function assertEquals(msg, expected, actual) {
        assertTrue(msg+": expected "+expected+", is "+actual, expected == actual);
    }

    function assertEqualsF(msg, expected, actual, accuracy) {
        assertTrue(msg+": expected "+expected+", is "+actual, (expected-actual).abs() < accuracy);
    }

    function assertNonNull(msg, actual) {
        assertTrue(msg+": expected not null, is "+actual, actual != null);
    }

    class AssertFailedException {
    }
}
}