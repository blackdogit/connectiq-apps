using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.WatchUi as UI;
using Toybox.Lang;

//! Very simple Settings Menu
//!
//! To use:
module BDIT {
module SettingsUtils {
    const VERSION = "20150328";

    class SettingsMenu extends UI.View {
        hidden var title = "Settings";
        hidden var onSelectMethod = null;

        hidden var items = [];
        hidden var no = 0;

        function initialize(options, onSelect) {
            var v = options.get(:title);
            if (v != null) { title = v; }
            self.onSelectMethod = onSelect;
        }

        function add(symbol, label, value) {
            items = BDIT.ArrayUtils.arrayAdd(items, items.size(), [symbol, label, value]);
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
            UI.pushView(self, getBehavior(), UI.SLIDE_LEFT);
        }

        hidden function onUpdate(dc) {
            // Normalize no
            if (no > items.size()) { no = 0; }
            if (no < 0) { no = items.size()-1; }

            dc.setColor(G.COLOR_BLACK, G.COLOR_WHITE);
            dc.clear();

            if (no < 0) { return; }

            var item = items[no];

            Sys.println("no "+no+": "+item[1]);
        }

        function getBehavior() {
            return new SettingsMenuBehavior(self);
        }

        hidden function getItem(symbol) {
            for (var i = 0; i < items.size(); i = i+1) {
                if (items[i][0] == symbol) { return items[i]; }
            }
            return null;
        }

        hidden function onMenuSelect() {
            onSelectMethod.invoke(self, items[no][0]);
            UI.requestUpdate();
        }
        hidden function onMenuMove(delta) {
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
                menu.onMenuMove(-1);
                return true;
            } else if (key == UI.KEY_UP) {
                menu.onMenuMove(1);
                return true;
            } else if (key == UI.KEY_ENTER) {
                menu.onMenuSelect();
                return true;
            } else if (key == UI.KEY_MENU) {
                return true;
            }
            return false;
        }
    }
}
}