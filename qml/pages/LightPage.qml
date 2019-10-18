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
        title: i18n.tr("Light & Proximity")
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
            function toggleLightLogging() {
                if(lightsensor.isLogging) {
                    lightsensor.stopLogging();
                } else {
                    lightsensor.startLogging();
                }
            }

            text: i18n.tr("Light sensor: ") + (lightsensor.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
            onClicked: toggleLightLogging()
        }
        MenuItem {
            function toggleProximityLogging() {
                if(proximitysensor.isLogging) {
                    proximitysensor.stopLogging();
                } else {
                    proximitysensor.startLogging();
                }
            }

            text: i18n.tr("Proximity sensor: ") + (proximitysensor.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
            onClicked: toggleProximityLogging()
        }
    }

    function formatNumber(n) {
        return '<b>' + n.toFixed(3) + ' Lux</b>';
    }

    function updateBrightnessPlot() {
        bplot.addValue(lightsensor.brightness);
        bplot.update();
    }

    Component.onCompleted: {
        lightsensor.activate(Constants.PART_PAGE);
        lightsensor.brightnessChanged.connect(updateBrightnessPlot);

        proximitysensor.activate(Constants.PART_PAGE);
    }
    Component.onDestruction: {
        lightsensor.deactivate(Constants.PART_PAGE);
        lightsensor.brightnessChanged.disconnect(updateBrightnessPlot);

        proximitysensor.deactivate(Constants.PART_PAGE);
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
                text: i18n.tr("Brightness")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: blabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: i18n.tr('Brightness: ') + page.formatNumber(lightsensor.brightness)
                }
                PlotWidget {
                    id: bplot
                    width: parent.width
                    height: units.gu(10)
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
            Label {
                text: i18n.tr("Proximity")
            }
            Label {
                id: proximityLabel
                font.pixelSize: Theme.fontSizeLarge
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: proximitysensor.detected
                font.strikeout: !proximitysensor.detected
                color: {
                    if(proximitysensor.detected) {
                        return Theme.highlightColor;
                    } else {
                        return Theme.secondaryColor;
                    }
                }
                text: i18n.tr('Proximity detected')
            }
        }
    }
}
