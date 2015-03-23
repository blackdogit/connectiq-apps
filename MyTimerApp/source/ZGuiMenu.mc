using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Position as Position;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.Time as Time;


module Gui {

hidden var colors = [
    Gfx.COLOR_BLACK,
    Gfx.COLOR_WHITE
];

class MenuTitle
{
    var label;

    function initialize() {
        self.label = "";
    }

    function draw(dc, active, x, y, width, height) {
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
        dc.fillRectangle(x, y, width, height);

        if (label != null) {
            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

            var cx = x + (width / 2);
            dc.drawText(cx, y + height / 2, Gfx.FONT_MEDIUM, label,
                    Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }
}

class MenuItem
{
    var label;
    var symbol;
    var value = null;

    function initialize(label, symbol) {
        self.label = label;
        self.symbol = symbol;
    }

    function setValue(value) {
        self.value = value;
    }

    function draw(dc, active, x, y, width, height) {
        active = (active ? 1 : 0);

        dc.setColor(colors[active], colors[active]);
        dc.fillRectangle(x, y, width, height);

        dc.setColor(colors[1 - active], Gfx.COLOR_TRANSPARENT);

        var cx = x + (width / 2);
        if (active) {

            if (value != null) {
                dc.drawText(cx, y + height / 4, Gfx.FONT_MEDIUM, label,
                            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);


                dc.drawText(cx, y + 3 * height / 4, Gfx.FONT_SMALL, value.toString(),
                        Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            }
            else {
                dc.drawText(cx, y + height / 2, Gfx.FONT_MEDIUM, label,
                        Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
            }

        }
        else {
            dc.drawText(cx, y + height / 2, Gfx.FONT_TINY, label,
                    Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }
}

class Menu extends Ui.View
{
    var items;
    var selection = 1;

    function initialize() {
        Sys.println("Menu.initialize");
        items = new [1];
        items[0] = new MenuTitle();
    }

    function onUpdate(dc) {
        Sys.println("Menu.onUpdate");

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();

        for (var i = -1; i < 2; ++i) {
            var n = selection + i;
            if (! (n < items.size())) {
                break;
            }

            var y1 = ((i + 1) * height) / 3;
            var y2 = ((i + 2) * height) / 3;
            var dy = y2 - y1;

            items[n].draw(dc, i == 0, 0, y1, width, dy);
        }
    }

    function setTitle(title) {
        Sys.println("Menu.setTitle");
        items[0].label = title;
    }

    function addItem(label, symbol) {
        Sys.println("Menu.addItem");
        var new_items = new [items.size() + 1];

        var i;
        for (i = 0; i < items.size(); ++i) {
            new_items[i] = items[i];
        }

        new_items[i] = new MenuItem(label, symbol);
        items = new_items;

        Ui.requestUpdate();

        return new_items[i];
    }

    function setValue(symbol, value) {
        Sys.println("Menu.setValue");
        for (var i = 1; i < items.size(); ++i) {
            if (items[i].symbol == symbol) {
                items[i].value = value;
                break;
            }
        }
    }

    function getValue(symbol) {
        Sys.println("Menu.getValue");
        for (var i = 1; i < items.size(); ++i) {
            if (items[i].symbol == symbol) {
                return items[i].value;
            }
        }

        return null;
    }

    function incrementSelection() {
        Sys.println("Menu.incrementSelection");
        var nitems = items.size() - 1;
        if (nitems < 1) {
            return false;
        }

        if (selection == 1) {
            selection = nitems;
        }
        else {
            selection -= 1;
        }

        Ui.requestUpdate();

        return true;
    }

    function decrementSelection() {
        Sys.println("Menu.decrementSelection");
        var nitems = items.size() - 1;
        if (nitems < 1) {
            return false;
        }

        if (selection == nitems) {
            selection = 1;
        }
        else {
            selection += 1;
        }

        Ui.requestUpdate();

        return true;
    }

    function acceptSelection(delegate) {
        Sys.println("Menu.acceptSelection");

        var nitems = items.size() - 1;
        if (nitems < 1) {
            return false;
        }

        Sys.println("->");
        var result = delegate.onMenuItem(items[selection].symbol);
        Sys.println("<-");

        Ui.requestUpdate();

        return result;
    }
}

class MenuInputDelegate extends Ui.InputDelegate
{
    var parent;

    function initialize(parent) {
        Sys.println("MenuInputDelegate.initialize");
        self.parent = parent;
    }

    function onKey(evt) {
        Sys.println("MenuInputDelegate.onKey");
        var key = evt.getKey();
        if (key == Ui.KEY_UP) {
            Sys.println("KEY_UP");
            return parent.incrementSelection();
        }
        else if (key == Ui.KEY_DOWN) {
            Sys.println("KEY_DOWN");
            return parent.decrementSelection();
        }
        else if (key == Ui.KEY_ENTER) {
            Sys.println("KEY_ENTER");

            var result = parent.acceptSelection(self);
            if (result) {
                Ui.popView(Ui.SLIDE_IMMEDIATE);
            }
            return result;
        }
        else if (key == Ui.KEY_ESC) {
            Sys.println("KEY_ESC");
            Ui.popView(Ui.SLIDE_IMMEDIATE);
        }

        return false;
    }

    function onTap(evt) {
        Sys.println("MenuInputDelegate.onTap");
        var type = evt.getType();
        if (type == Ui.CLICK_TYPE_TAP) {
            var result = parent.acceptSelection(self);
            if (result) {
                Ui.popView(Ui.SLIDE_IMMEDIATE);
            }
            return result;
        }

        return false;
    }

    function onSwipe(evt) {
        Sys.println("MenuInputDelegate.onSwipe");
        var dir = evt.getDirection();
        if (dir == Ui.SWIPE_UP) {
            return parent.decrementSelection();
        }
        else if (dir == Ui.SWIPE_DOWN) {
            return parent.incrementSelection();
        }
        else {
            return false;
        }

        return true;
    }

    function onMenuItem(item) {
        Sys.println("MenuInputDelegate.onMenuItem");
        return false;
    }
}

}
