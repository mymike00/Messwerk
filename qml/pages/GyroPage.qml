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
        title: i18n.tr("Gyroscope")
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
                if(gyroscope.isLogging) {
                    gyroscope.stopLogging();
                } else {
                    gyroscope.startLogging();
                }
            }

            text: (gyroscope.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
            onClicked: toggleLogging()
        }
        MenuItem {
            function toggleUnit() {
                useRad = !useRad;

                xplot.reset();
                yplot.reset();
                zplot.reset();
            }

            text: i18n.tr("Change unit to " + (useRad ? '°/s' : 'rad/s'))
            onClicked: toggleUnit()
        }
    }

    property bool useRad: false;

    function convertNumber(n) {
        if(useRad) {
            n *= 0.017453; // *pi/180
        }

        return n;
    }

    function formatNumber(n) {
        var unit;

        if(useRad) {
            unit = 'rad/s';
        } else {
            unit = '°/s'
        }

        return '<b>' + convertNumber(n).toFixed(3) + ' ' + unit + '</b>';
    }

    function updateXPlot() {
        xplot.addValue(convertNumber(gyroscope.rx));
        xplot.update();
    }

    function updateYPlot() {
        yplot.addValue(convertNumber(gyroscope.ry));
        yplot.update();
    }

    function updateZPlot() {
        zplot.addValue(convertNumber(gyroscope.rz));
        zplot.update();
    }

    Component.onCompleted: {
        gyroscope.activate(Constants.PART_PAGE)
        gyroscope.rxChanged.connect(updateXPlot);
        gyroscope.ryChanged.connect(updateYPlot);
        gyroscope.rzChanged.connect(updateZPlot);
    }

    Component.onDestruction: {
        gyroscope.rxChanged.disconnect(updateXPlot);
        gyroscope.ryChanged.disconnect(updateYPlot);
        gyroscope.rzChanged.disconnect(updateZPlot);
        gyroscope.deactivate(Constants.PART_PAGE)
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

            Column {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    id: xlabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: 'X: ' + page.formatNumber(gyroscope.rx)
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
                    text: 'Y: ' + page.formatNumber(gyroscope.ry)
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
                    text: 'Z: ' + page.formatNumber(gyroscope.rz)
                }
                PlotWidget {
                    id: zplot
                    width: parent.width
                    height: units.gu(10)
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
        }
    }
}
