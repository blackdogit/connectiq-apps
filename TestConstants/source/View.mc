using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as G;
using Toybox.Math;

class TestConstantsView extends Ui.View {

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));

        Sys.println("onLayout() wxh="+dc.getWidth()+"x"+dc.getHeight() );

        Sys.println("** Font Height:");
        Sys.println("XTINY: "+dc.getFontHeight(G.FONT_XTINY));
        Sys.println("TINY: "+dc.getFontHeight(G.FONT_TINY));
        Sys.println("SMALL: "+dc.getFontHeight(G.FONT_SMALL));
        Sys.println("MEDIUM: "+dc.getFontHeight(G.FONT_MEDIUM));
        Sys.println("LARGE: "+dc.getFontHeight(G.FONT_LARGE));
        Sys.println("NUMBER_MILD: "+dc.getFontHeight(G.FONT_NUMBER_MILD));
        Sys.println("NUMBER_MEDIUM: "+dc.getFontHeight(G.FONT_NUMBER_MEDIUM));
        Sys.println("NUMBER_HOT: "+dc.getFontHeight(G.FONT_NUMBER_HOT));
        Sys.println("NUMBER_THAI_HOT: "+dc.getFontHeight(G.FONT_NUMBER_THAI_HOT));

        Sys.println("** Data types:");
        Sys.println("Math.PI: "+MCUtils.typeof(Math.PI));

    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {

    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

}