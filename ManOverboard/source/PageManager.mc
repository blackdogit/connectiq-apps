module ManOverboard {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Position as Pos;
using Toybox.Timer;
using Toybox.Time;

//! Manager of pages.
//! Handles next/previous page
module PageManager {
    //! Array with all defined pages
    hidden var pages = [new DistSpeedView(), new TargetView()];

    hidden var pageNo = 0;

    enum {
        FIRST, PREVIOUS, CURRENT, NEXT
    }

    //! Returns the wanted page
    function getPage(which) {
        if (which == FIRST) {
            pageNo = 0;
        } else if (which == PREVIOUS) {
            pageNo = pageNo-1;
            if (pageNo < 0) { pageNo = pages.size()-1; }
        } else if (which == CURRENT) {
            // Nothing...
        } else if (which == NEXT) {
            pageNo = pageNo+1;
            if (pageNo >= pages.size()) { pageNo = 0; }
        } else {
            // Nothing...
        }

        return pages[pageNo];
    }

    function onPageKey(evt) {
        var key = evt.getKey();
        if (key == UI.KEY_DOWN) {
            var page = PageManager.getPage(PageManager.NEXT);
            UI.switchToView(page, page.getBehavior(), UI.SLIDE_UP);
            return true;
        } else if (key == UI.KEY_UP) {
            var page = PageManager.getPage(PageManager.PREVIOUS);
            UI.switchToView(page, page.getBehavior(), UI.SLIDE_UP);
            return true;
        }

        return false;
    }
}
}