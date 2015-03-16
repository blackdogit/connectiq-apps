module ManOverboard {
using Toybox.Application as App;
using Toybox.WatchUi as UI;
using Toybox.System as Sys;
using Toybox.Attention as Att;
using Toybox.Graphics as G;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer;
using Toybox.Time;

class BaseBehavior extends UI.BehaviorDelegate {
    function nextPage() {
        var page = PageManager.getPage(PageManager.NEXT);
        UI.switchToView(page, page.getBehavior(), UI.SLIDE_UP);
    }
    function previousPage() {
        var page = PageManager.getPage(PageManager.PREVIOUS);
        UI.switchToView(page, page.getBehavior(), UI.SLIDE_UP);
    }
}
}