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
        title: i18n.tr("Magnetometer")
        navigationActions: UITK.Action {
            iconName: "back"
            text: i18n.tr('Back')
            onTriggered: page.StackView.view.pop();
        }
    }

    Menu {
        id: menu
        x: parent.width - width
        MenuItem {
            function toggleLogging() {
                if(magnetometer.isLogging) {
                    magnetometer.stopLogging();
                } else {
                    magnetometer.startLogging();
                }
            }

            text: (magnetometer.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
            onClicked: toggleLogging()
        }
        }

    function formatNumber(n) {
        n *= 1e3;

        return '<b>' + n.toFixed(4) + ' mT</b>';
    }

    function formatPercentage(n) {
        n *= 100;

        return '<b>' + n.toFixed(0) + ' %</b>';
    }

    function updateXPlot() {
        xplot.addValue(magnetometer.mx);
        xplot.update();
    }

    function updateYPlot() {
        yplot.addValue(magnetometer.my);
        yplot.update();
    }

    function updateZPlot() {
        zplot.addValue(magnetometer.mz);
        zplot.update();
    }

    Component.onCompleted: {
        magnetometer.activate(Constants.PART_PAGE);
        magnetometer.mxChanged.connect(updateXPlot);
        magnetometer.myChanged.connect(updateYPlot);
        magnetometer.mzChanged.connect(updateZPlot);
    }

    Component.onDestruction: {
        magnetometer.mxChanged.disconnect(updateXPlot);
        magnetometer.myChanged.disconnect(updateYPlot);
        magnetometer.mzChanged.disconnect(updateZPlot);
        magnetometer.deactivate(Constants.PART_PAGE);
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
                    text: 'X: ' + page.formatNumber(magnetometer.mx)
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
                    text: 'Y: ' + page.formatNumber(magnetometer.my)
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
                    text: 'Z: ' + page.formatNumber(magnetometer.mz)
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
                id: precisionlabel
                font.pixelSize: Theme.fontSizeLarge
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                text: 'Precision: ' + page.formatPercentage(magnetometer.precision)
            }
        }
    }
}
