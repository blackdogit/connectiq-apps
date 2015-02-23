//! Various utilities aimed at Monkey-C as a language
module MCUtils {
    using Toybox.Lang;
    using Toybox.Position;
    using Toybox.WatchUi as Ui;

    //! Returns the type of the specified obj as a string
    //! @param obj [Object]: the object to test
    //! @returns [String]: the type of the object if found or otherwise "-UNKNON-"
    function typeof(obj) {
        if (obj == null) {
            return "null";
        }
        if (obj instanceof Lang.Number) {
            return "Number";
        }
        if (obj instanceof Lang.Double) {
            return "Double";
        }
        if (obj instanceof Lang.Float) {
            return "Float";
        }
        if (Toybox has :Position && obj instanceof Position.Location) {
            return "Location";
        }
        if (Toybox has :Position && obj instanceof Position.Location) {
            return "Location";
        }
        if (obj instanceof Lang.Array) {
            return "Array";
        }
//        for (var t : TYPES.keys()) {
//            if (obj instanceof t) {
//                return TYPES[t];
//            }
//        }

        return "-UNKNOWN-";
    }
}