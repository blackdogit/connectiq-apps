using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

module BDIT {
module StringUtils {
    const VERSION = "20150411";

    function replace(m, from, to) {
        //Sys.println("replace('"+m+"', '"+from+"', '"+to+"')");
        var res = "";
        var fromL = from.length();
        while (m != null && m.length() > 0) {
            var n = m.find(from);
            //Sys.println("n="+n);
            if (n == null) {
                res = res+m;
                m = null;
            } else {
                if (n == 0) {
                    res = res+to;
                } else {
                    res = res+m.substring(0, n)+to;
                }
                //Sys.println("'"+m+"'.substring("+(n+fromL)+", "+m.length()+")");
                m = m.substring(n+fromL, m.length());
            }
            //Sys.println(">>res='"+res+"', m='"+m+"'");
        }
        return res;
    }



    //! Divide a long text into smaller lines with max maxWidth pixels per line...
    //! Returns an array with the lines.
    //!
    //! Will not break words.
    //! Will remove multiple spaces
    //! Will respect existing new-lines (even multiple)
    function breakupLines(dc, font, m, maxWidth) {
        if (maxWidth == null) { maxWidth = dc.getWidth(); }
        //Sys.println("breakupLines(dc, "+font+", '"+m+"', "+maxWidth+")");
        //Sys.println("m='"+m+"'");
        var lines = new[100];
        var no = 0;
        var line = "";
        while (m != null && m.length() > 0 && no < lines.size()) {
            // Find the next space, new-line or the end-of-line
            var n = m.find(" ");
            var nl = m.find("\n");
            //Sys.println("n="+n+", nl="+nl);
            if (n == null || (nl != null && nl < n)) {
                n = nl;
                nl = (nl != null);
            } else {
                nl = false;
            }
            var nextWord;
            if (n == null) {
                nextWord = m;
                m = null;
            } else if (n == 0) {
                nextWord = "";
                m = m.substring(n+1, m.length());
            } else {
                nextWord = m.substring(0, n);
                m = m.substring(n+1, m.length());
            }
            // We now have:
            // - nextWord is the next word to add (possibly "")
            // - nl is true if the next word ended with a new-line
            //Sys.println("line='"+line+"', nextWord='"+nextWord+"', nl="+nl);

            // If we already have words in the current line, then check if it gets to be too long
            var nextLine = line;
            if (line.length() > 0 || nl) {
                if (nextWord.length() > 0) {
                    if (nextLine.length() > 0) { nextLine = nextLine+" "; }
                    nextLine = nextLine+nextWord;
                }
                // If the line becomes too long make a new
                var w = dc.getTextWidthInPixels(nextLine, font);
                if (w > maxWidth) {
                    lines[no] = line;
                    no = no+1;
                    line = nextWord;
                    nextLine = nextWord;
                }
                // If we have a new-line, then make a new
                if (nl) {
                    lines[no] = nextLine;
                    no = no+1;
                    nextLine = "";
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