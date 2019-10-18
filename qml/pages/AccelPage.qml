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
        title: i18n.tr("Accelerometer")
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
            function toggleLogging() {
                if(accelerometer.isLogging) {
                    accelerometer.stopLogging();
                } else {
                    accelerometer.startLogging();
                }
            }

            text: (accelerometer.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
            onClicked: toggleLogging()
        }
        MenuItem {
            function toggleUnit() {
                useGs = !useGs;

                xplot.reset();
                yplot.reset();
                zplot.reset();
            }

            text: i18n.tr("Change unit to " + (useGs ? 'm/s²' : 'g'))
            onClicked: toggleUnit()
        }
    }

    property bool useGs: false;

    function convertNumber(n) {
        if(useGs) {
            n /= 9.81; // *pi/180
        }

        return n;
    }

    function formatNumber(n) {
        var unit;

        if(useGs) {
            unit = 'g';
        } else {
            unit = 'm/s²'
        }

        return '<b>' + convertNumber(n).toFixed(3) + ' ' + unit + '</b>';
    }

    function updateXPlot() {
        xplot.addValue(convertNumber(accelerometer.ax));
        xplot.update();
    }

    function updateYPlot() {
        yplot.addValue(convertNumber(accelerometer.ay));
        yplot.update();
    }

    function updateZPlot() {
        zplot.addValue(convertNumber(accelerometer.az));
        zplot.update();
    }

    Component.onCompleted: {
        accelerometer.activate(Constants.PART_PAGE);
        accelerometer.axChanged.connect(updateXPlot);
        accelerometer.ayChanged.connect(updateYPlot);
        accelerometer.azChanged.connect(updateZPlot);
    }

    Component.onDestruction: {
        accelerometer.axChanged.disconnect(updateXPlot);
        accelerometer.ayChanged.disconnect(updateYPlot);
        accelerometer.azChanged.disconnect(updateZPlot);
        accelerometer.deactivate(Constants.PART_PAGE)
    }

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

            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: xlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: 'X: ' + page.formatNumber(accelerometer.ax)
                }
                PlotWidget {
                    id: xplot
                    width: parent.width
                    height: units.gu(10)
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: ylabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: 'Y: ' + page.formatNumber(accelerometer.ay)
                }
                PlotWidget {
                    id: yplot
                    width: parent.width
                    height: units.gu(10)
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: zlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: 'Z: ' + page.formatNumber(accelerometer.az)
                }
                PlotWidget {
                    id: zplot
                    width: parent.width
                    height: units.gu(10)
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
            Label {
                id: abslabel
                font.pixelSize: Theme.fontSizeLarge
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                text: 'Absolute: ' + page.formatNumber(accelerometer.abs)
            }
            Label {
                id: absnogravlabel
                font.pixelSize: Theme.fontSizeLarge
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                text: 'Without gravity: ' + page.formatNumber(accelerometer.abs - 9.81)
            }
        }
    }
}
