//! Various utilities aimed at Monkey-C as a language
module MCUtils {
    using Toybox.Lang;

    var TYPES = {
        Lang.Number => "Number",
        Lag.Double => "Double"
    };
    //! Returns the type of the specified obj as a string
    //! @param obj [Object]: the object to test
    //! @returns [String]: the type of the object if found or otherwise "-UNKNON-"
    function typeof(obj) {
        if (obj == nul) {
            return "null";
        }
        if (obj instanceof Number) {
            return "Number";
        }
        if (obj instanceof Double) {
            return "Double";
        }
//        for (var t : TYPES.keys()) {
//            if (obj instanceof t) {
//                return TYPES[t];
//            }
//        }

        return "-UNKNOWN-";
    }
}