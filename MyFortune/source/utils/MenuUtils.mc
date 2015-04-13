using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Graphics as G;
using Toybox.Lang;

// Depends on
// - ArrayUtils

//! Very simple Settings Menu
//!
//! To use:
module BDIT {
module MenuUtils {
    const VERSION = "20150412";

    class Menu extends UI.View {
        hidden var title = "Settings";
        hidden var onSelectMethod = null;

        hidden var items = [];
        hidden var dict = {};
        hidden var no = 0;

        function initialize(options, onSelect) {
            if (options != null) {
                var v = options.get(:title);
                if (v != null) { title = v; }
            }
            self.onSelectMethod = onSelect;
        }

        function addItem(symbol, label, value) {
            var item = [symbol, label, value];
            items = BDIT.ArrayUtils.arrayAdd(items, items.size(), item);
            dict[symbol] = item;
        }

        function setLabel(symbol, label) {
            var i = getItem(symbol);
            if (i != null) { i[1] = label; }
        }

        function setValue(symbol, value) {
            var i = getItem(symbol);
            if (i != null) { i[2] = value; }
        }

        function show() {
            //Sys.println("show");
            UI.pushView(self, getBehavior(self), UI.SLIDE_LEFT);
        }

        var largeFont = G.FONT_MEDIUM;
        var smallFont = G.FONT_SMALL;


        function onUpdate(dc) {
            // Normalize no
            var s = items.size();
            if (no < 0) { no = no+s; }
            if (no >= s) { no = no-s; }

            //Sys.println("items="+items.toString());
            //Sys.println("no="+no);

            dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
            dc.clear();

            //if (no < 0) { return; }

            //Sys.println("no "+no+": "+items[no][1]);

            var h = dc.getHeight();
            var w = dc.getWidth();
            var y = 0;

            var largeHeight = dc.getFontHeight(largeFont);
            var smallHeight = dc.getFontHeight(smallFont);
            var lineHeight = 4;
            var padding = 3;

            var dy = padding+largeHeight+2+smallHeight+padding;
            var maxLines = ((h+lineHeight)/(dy+lineHeight)).toNumber();
            dy = ((h+lineHeight)/maxLines).toNumber()-lineHeight;
            padding = ((dy-(largeHeight+2+smallHeight))/2).toNumber();

            //Sys.println("lh="+largeHeight+" sh="+smallHeight+", dy="+dy+", h="+h);
            var i = no-1;
            while (y < h && i < s) {
                //Sys.println("i="+i+", y="+y);
                if (i == -1) {
                    dc.setColor(G.COLOR_DK_GRAY, G.COLOR_DK_GRAY);
                    dc.fillRectangle(0, y, w, dy);
                    dc.setColor(G.COLOR_LT_GRAY, G.COLOR_DK_GRAY);
                    dc.drawText(w/2, y+dy/2, largeFont, title, G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
                    dc.setColor(G.COLOR_DK_BLUE, G.COLOR_DK_BLUE);
                    dc.fillRectangle(0, y+dy, w, lineHeight);
                } else if (i >= 0) {
                    var item = items[i];
                    var label = item[1];
                    var value = item[2];
                    if (i == no) {
                        dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
                        dc.fillRectangle(0, y, w, dy);
                        dc.setColor(G.COLOR_BLACK, G.COLOR_WHITE);
                    } else {
                        dc.setColor(G.COLOR_WHITE, G.COLOR_BLACK);
                    }
                    if (value == null) {
                        dc.drawText(w/2, y+dy/2, largeFont, label, G.TEXT_JUSTIFY_CENTER|G.TEXT_JUSTIFY_VCENTER);
                    } else {
                        dc.drawText(w/2, y+padding, largeFont, label, G.TEXT_JUSTIFY_CENTER);
                        dc.drawText(w/2, y+padding+largeHeight+2, smallFont, value.toString(), G.TEXT_JUSTIFY_CENTER);
                    }
                    dc.setColor(G.COLOR_DK_GREEN, G.COLOR_DK_GREEN);
                    dc.fillRectangle(0, y+dy, w, lineHeight);
                }
                y = y+dy+lineHeight;
                i = i+1;
            }
        }

        function getBehavior() {
            return new SettingsMenuBehavior(self);
        }

        hidden function getItem(symbol) {
            return dict[symbol];
            //for (var i = 0; i < items.size(); i = i+1) {
            //    if (items[i][0] == symbol) { return items[i]; }
            //}
            //return null;
        }

        function onMenuSelect() {
            onSelectMethod.invoke(self, items[no][0]);
            UI.requestUpdate();
        }
        function onMenuMove(delta) {
            no = no+delta;
            UI.requestUpdate();
        }
    }

    hidden class SettingsMenuBehavior extends UI.InputDelegate {
        var menu;
        function initialize(menu) {
            self.menu = menu;
        }
        function onKey(evt) {
            var key = evt.getKey();
            //Sys.println("key="+key);
            if (key == UI.KEY_ESC) {
                UI.popView(UI.SLIDE_RIGHT);
                return true;
            } else if (key == UI.KEY_DOWN) {
                menu.onMenuMove(1);
                return true;
            } else if (key == UI.KEY_UP) {
                menu.onMenuMove(-1);
                return true;
            } else if (key == UI.KEY_ENTER) {
                menu.onMenuSelect();
                return true;
            } else if (key == UI.KEY_MENU) {
                return true;
            }
            return false;
        }

        function onSwipe(evt) {
            var dir = evt.getDirection();
            if (dir == UI.SWIPE_DOWN) {
                menu.onMenuMove(-1);
                return true;
            }
            if (dir == UI.SWIPE_UP) {
                menu.onMenuMove(1);
                return true;
            }
            return false;
        }
    }
}
}