module DistUtilsTests {
    using BDIT.MCUnit;
    using BDIT.DistanceUtils;
    using Toybox.Math;
    using Toybox.Position as Pos;

    function test() {
        var p1 = new Pos.Location({:latitude => 0, :longitude => 0, :format => :degrees});

        var p2 = new Pos.Location({:latitude => 55.617474, :longitude => 12.494658, :format => :degrees});
        var p3 = new Pos.Location({:latitude => 55.639086, :longitude => 12.550019, :format => :degrees});

        var p4 = new Pos.Location({:latitude => 10, :longitude => 10, :format => :degrees});
        var p5 = new Pos.Location({:latitude => 10, :longitude => 11, :format => :degrees});
        var p6 = new Pos.Location({:latitude => 11, :longitude => 10, :format => :degrees});

        var pstart = new Pos.Location({:latitude => Math.PI, :longitude => Math.PI, :format => :radians});

        t(null, null, null, null);
        t(p1, null, null, null);
        t(null, p2, null, null);
        t(pstart, p2, null, null);

        //t(p4, p5, 109523, -90);
        t(p4, p6, 111209, 180);

        t(p1, p2, 6329208, 192.6);
        t(p3, p2, 4399.39, 68.7);
    }

    function t(p1, p2, expectedDist, expectedHeading) {
        var r = DistanceUtils.calcDistHeading(p1, p2);
        MCUnit.assertNonNull("result not null", r);
        if (expectedDist == null) {
            MCUnit.assertEquals("distance", expectedDist, r[0]);
        } else {
            MCUnit.assertEqualsF("distance", expectedDist, r[0], expectedDist/100000);
        }
        if (expectedHeading == null) {
            MCUnit.assertEquals("heading", expectedHeading, r[1]);
        } else {
            MCUnit.assertEqualsF("heading", expectedHeading, r[1], 1);
        }
    }
}