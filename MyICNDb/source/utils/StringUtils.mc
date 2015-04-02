using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

module BDIT {
module StringUtils {
    const VERSION = "20150323";

    //! Divide a long text into smaller lines with max maxWidth pixels per line...
    //! Returns an array with the lines.
    function breakupLines(dc, font, m, maxWidth) {
        if (maxWidth == null) { maxWidth = dc.getWidth(); }
        Sys.println("m='"+m+"'");
        var lines = new[100];
        var no = 0;
        var line = "";
        while (m != null && m.length() > 0 && no < lines.size()) {
            // Find the next space or the end-of-line
            var n = m.find(" ");
            var nextWord;
            if (n == null) {
                nextWord = m;
                m = null;
            } else {
                nextWord = m.substring(0, n);
                m = m.substring(n+1, m.length());
            }
            //Sys.println("lines='"+line+"', nextWord='"+nextWord+"'");

            // If we already have words in the current line, then check if it gets to be too long
            var nextLine;
            if (line.length() > 0) {
                nextLine = line+" "+nextWord;
                var w = dc.getTextWidthInPixels(nextLine, font);
                if (w > maxWidth) {
                    lines[no] = line;
                    no = no+1;
                    line = "";
                    nextLine = nextWord;
                }
            } else {
                nextLine = nextWord;
            }
            line = nextLine;
        }
        if (no < lines.size()) {
            lines[no] = line;
            no = no+1;
        }

        var res = new[no];
        for (var i = 0; i < no; i = i+1) {
            res[i] = lines[i];
        }

        return res;
    }
}
}