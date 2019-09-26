import QtQuick 2.12
import QtQuick.Controls 2.12

import "../Theme.js" as Theme

Page {
    id: page

    header: Label {
        text: qsTr("Select Sensor")
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    Flickable {
        anchors.fill: parent
/*
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsDialog.qml"))
            }
            MenuItem {
                text: qsTr("Info")
                onClicked: pageStack.push(Qt.resolvedUrl("InfoPage.qml"))
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

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Position")
                onClicked: pageStack.push(Qt.resolvedUrl("PositionPage.qml"))
                highlighted: satelliteinfo.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("GNSS Satellites")
                onClicked: pageStack.push(Qt.resolvedUrl("SatellitePage.qml"))
                highlighted: satelliteinfo.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Rotation")
                onClicked: pageStack.push(Qt.resolvedUrl("RotationPage.qml"))
                highlighted: rotationsensor.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Accelerometer")
                onClicked: pageStack.push(Qt.resolvedUrl("AccelPage.qml"))
                highlighted: accelerometer.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Gyroscope")
                onClicked: pageStack.push(Qt.resolvedUrl("GyroPage.qml"))
                highlighted: gyroscope.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Magnetometer")
                onClicked: pageStack.push(Qt.resolvedUrl("MagnetPage.qml"))
                highlighted: magnetometer.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Light & Proximity")
                onClicked: pageStack.push(Qt.resolvedUrl("LightPage.qml"))
                highlighted: (lightsensor.isLogging || proximitysensor.isLogging)
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Pressure Sensor")
                onClicked: pageStack.push(Qt.resolvedUrl("PressurePage.qml"))
                highlighted: pressuresensor.isLogging
            }
        }
    }
}


