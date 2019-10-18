import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UITK
import harbour.messwerk.MesswerkWidgets 1.0

import "../Constants.js" as Constants
import "../Theme.js" as Theme

Page {
    id: page
    header: UITK.PageHeader {
        id: pageH
        title: i18n.tr("Position")
        navigationActions: UITK.Action {
            iconName: "back"
            text: i18n.tr('Back')
            onTriggered: page.StackView.view.pop();
        }
        trailingActionBar.actions: [
            UITK.Action {
                onTriggered: !menu.visible ? menu.open() : menu.close()
                iconName: "contextual-menu"
            }
        ]
    }

    Menu {
        id: menu
        x: parent.width - width
        MenuItem {
            function nextCoordFormat() {
                decimalCoord = !decimalCoord;
            }

            text: i18n.tr("Coordinate format: ") + (decimalCoord ? i18n.tr("deg./min./sec.") : i18n.tr("decimal"))
            onClicked: nextCoordFormat()
        }
        MenuItem {
            function togglePositionLogging() {
                if(positionsensor.isLogging) {
                    positionsensor.stopLogging();
                } else {
                    positionsensor.startLogging();
                }
            }

            text: i18n.tr("Position: ") + (positionsensor.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
            onClicked: togglePositionLogging()
        }
    }

    property bool decimalCoord: true;

    function formatCoordinate(n, isLon) {
        if(decimalCoord) {
            return '<b>' + n.toFixed(6) + ' °</b>';
        } else {
            var coordText = "";

            var absn = Math.abs(n);
            var deg = Math.floor(absn);
            var min = Math.floor(absn * 60) % 60;
            var sec = Math.floor(absn * 3600) % 60;

            coordText  = deg + "° ";
            coordText += min + "' ";
            coordText += sec + "\" ";

            if(isLon) { // longitude: east/west
                if(n >= 0) {
                    coordText += "E";
                } else {
                    coordText += "W";
                }
            } else { // latitude: north/south
                if(n >= 0) {
                    coordText += "N";
                } else {
                    coordText += "S";
                }
            }

            return '<b>' + coordText + '</b>';
        }
    }

    function formatAltitude(n) {
        if(!isFinite(n)) {
            return '<b>N/A</b>';
        } else {
            return '<b>' + n.toFixed(2) + ' m</b>';
        }
    }

    function formatAccuracy(n) {
        if(n < 0) {
            return '<b>N/A</b>';
        } else {
            return '<b>' + n.toFixed(2) + ' m</b>';
        }
    }

    function formatFix(n) {
        switch(n) {
            case Constants.COORD_2D:
                return '<b>2D</b>';

            case Constants.COORD_3D:
                return '<b>3D</b>';

            case Constants.COORD_INVALID:
                return '<b>None</b>';

            default:
                return '<b>Unknown</b>';
        };
    }

    Component.onCompleted: {
        positionsensor.activate(Constants.PART_PAGE);
    }
    Component.onDestruction: {
        positionsensor.deactivate(Constants.PART_PAGE);
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    Flickable {
        anchors {
            fill: parent
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }

        // Tell Flickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            Label {
                text: i18n.tr("WGS84 Coordinates")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: fixlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Fix: ') + page.formatFix(positionsensor.coordType)
                }
                Label {
                    id: latlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Latitude: ') + page.formatCoordinate(positionsensor.latitude, false)
                }
                Label {
                    id: lonlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Longitude: ') + page.formatCoordinate(positionsensor.longitude, true)
                }
                Label {
                    id: altlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Altitude: ') + page.formatAltitude(positionsensor.altitude)
                }
            }
            Label {
                text: i18n.tr("Accuracy")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: horzAccLabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Horizontal: ') + page.formatAccuracy(positionsensor.horzAccuracy)
                }
                Label {
                    id: vertAccLabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Vertical: ') + page.formatAccuracy(positionsensor.vertAccuracy)
                }
            }
            Label {
                text: i18n.tr("Maidenhead Locator")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: locatorLabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Grid: ') + '<b>' + positionsensor.maidenhead + '</b>'
                }
            }
        }
    }
}
