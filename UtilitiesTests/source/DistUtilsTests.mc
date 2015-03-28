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

        var p7 = new Pos.Location({:latitude => 55.619946, :longitude => 12.490420, :format => :degrees});
        var p8 = new Pos.Location({:latitude => 55.619304, :longitude => 12.491708, :format => :degrees});

        var pstart = new Pos.Location({:latitude => Math.PI, :longitude => Math.PI, :format => :radians});

        t(null, null, null, null);
        t(p1, null, null, null);
        t(null, p2, null, null);
        t(pstart, p2, null, null);

        t(p4, p5, 109505.58, -90);
        t(p5, p4, 109505.58, 90);
        t(p4, p6, 111194, 180);
        t(p6, p4, 111194, 0);

        t(p1, p2, 6287067, 192.6);
        t(p3, p2, 4225.42, 68.7);

        t(p8, p7, 107.7647, 116);
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