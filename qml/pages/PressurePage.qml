import QtQuick 2.12
import QtQuick.Controls 2.12
import harbour.messwerk.MesswerkWidgets 1.0

import "../Constants.js" as Constants
import "../Theme.js" as Theme

Page {
    id: page
    header: Label { text: qsTr("Pressure Sensor") }

    function formatNumber(n) {
        return '<b>' + n.toFixed(3) + ' Pa</b>';
    }

    function updatePressurePlot() {
        pressureplot.addValue(pressuresensor.pressure);
        pressureplot.update();
    }

    Component.onCompleted: {
        pressuresensor.activate(Constants.PART_PAGE);
        pressuresensor.pressureChanged.connect(updatePressurePlot);
    }

    Component.onDestruction: {
        pressuresensor.pressureChanged.disconnect(updatePressurePlot);
        pressuresensor.deactivate(Constants.PART_PAGE)
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    Flickable {
        anchors.fill: parent
/*
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                function toggleLogging() {
                    if(pressuresensor.isLogging) {
                        pressuresensor.stopLogging();
                    } else {
                        pressuresensor.startLogging();
                    }
                }

                text: (pressuresensor.isLogging ? qsTr("Stop") : qsTr("Start")) + qsTr(" logging")
                onClicked: toggleLogging()
            }
        }
*/
        // Tell SilicaFlickable the height of its content.
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
                    id: pressurelabel
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    text: 'Pressure: ' + page.formatNumber(pressuresensor.pressure)
                }
                PlotWidget {
                    id: pressureplot
                    width: parent.width
                    height: 150
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
        }
    }
}


