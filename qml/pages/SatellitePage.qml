import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UITK
import harbour.messwerk.MesswerkWidgets 1.0

import "../Constants.js" as Constants
import "../Theme.js" as Theme

Page {
    id: page
    property var headerHeight: pageH.height
    header: UITK.PageHeader {
        id: pageH
        title: i18n.tr("Position")
        navigationActions: UITK.Action {
            iconName: "back"
            text: i18n.tr('Back')
            onTriggered: page.StackView.view.pop();
        }
    }

    function updateSkyPlot() {
        skyPlot.northDirection = rotationsensor.rz;
        skyPlot.update();
    }

    Component.onCompleted: {
        skyPlot.setSatelliteInfo(satelliteinfo);
        strengthPlot.setSatelliteInfo(satelliteinfo);
        satelliteinfo.newDataAvailable.connect(skyPlot.update)
        satelliteinfo.newDataAvailable.connect(strengthPlot.update)
        satelliteinfo.activate(Constants.PART_PAGE);
        rotationsensor.activate(Constants.PART_PAGE)
        rotationsensor.rzChanged.connect(updateSkyPlot);
    }

    Component.onDestruction: {
        rotationsensor.rzChanged.disconnect(updateSkyPlot);
        satelliteinfo.deactivate(Constants.PART_PAGE);
        rotationsensor.deactivate(Constants.PART_PAGE);
        satelliteinfo.newDataAvailable.disconnect(skyPlot.update)
        satelliteinfo.newDataAvailable.disconnect(strengthPlot.update)
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
/*
        PullDownMenu {
            MenuItem {
                function toggleLogging() {
                    if(satelliteinfo.isLogging) {
                        satelliteinfo.stopLogging();
                    } else {
                        satelliteinfo.startLogging();
                    }
                }

                text: (satelliteinfo.isLogging ? i18n.tr("Stop") : i18n.tr("Start")) + i18n.tr(" logging")
                onClicked: toggleLogging()
            }
        }
*/
        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            SatellitePosWidget {
                id: skyPlot
                width: parent.width
                height: parent.width
                visibleColor: Theme.primaryColor
                usedColor: Theme.highlightColor
                scaleColor: Theme.secondaryColor
                northColor: Theme.secondaryHighlightColor
            }
            SatelliteStrengthWidget {
                id: strengthPlot
                width: parent.width
                height: 200
                visibleColor: Theme.primaryColor
                usedColor: Theme.highlightColor
                scaleColor: Theme.secondaryColor
            }
        }
    }
}
