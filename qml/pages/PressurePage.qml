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
        title: i18n.tr("Pressure Sensor")
        navigationActions: UITK.Action {
            iconName: "back"
            text: i18n.tr('Back')
            onTriggered: page.StackView.view.pop();
        }
    }

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
        anchors {
            fill: parent
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }
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

                text: (pressuresensor.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
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
                    height: units.gu(10)
                    plotColor: Theme.highlightColor
                    scaleColor: Theme.secondaryHighlightColor
                }
            }
        }
    }
}
