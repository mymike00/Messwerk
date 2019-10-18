import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UITK

import "../Theme.js" as Theme

Page {
    id: page
    property var headerHeight: pageH.height

    header: UITK.PageHeader {
        id: pageH
        title: i18n.tr("Select Sensor")
        trailingActionBar.actions: [
            // UITK.Action {    //FIXME
            //     text: i18n.tr("Settings")
            //     iconName: "settings"
            //     onTriggered: pageStackView.push(Qt.resolvedUrl("SettingsDialog.qml"))
            // },
            UITK.Action {
                text: i18n.tr("Info")
                iconName: "info"
                onTriggered: pageStackView.push(Qt.resolvedUrl("InfoPage.qml"))
            }
        ]
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

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Position")
                onClicked: pageStackView.push(Qt.resolvedUrl("PositionPage.qml"))
                highlighted: satelliteinfo.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("GNSS Satellites")
                onClicked: pageStackView.push(Qt.resolvedUrl("SatellitePage.qml"))
                highlighted: satelliteinfo.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Rotation")
                onClicked: pageStackView.push(Qt.resolvedUrl("RotationPage.qml"))
                highlighted: rotationsensor.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Accelerometer")
                onClicked: pageStackView.push(Qt.resolvedUrl("AccelPage.qml"))
                highlighted: accelerometer.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Gyroscope")
                onClicked: pageStackView.push(Qt.resolvedUrl("GyroPage.qml"))
                highlighted: gyroscope.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Magnetometer")
                onClicked: pageStackView.push(Qt.resolvedUrl("MagnetPage.qml"))
                highlighted: magnetometer.isLogging
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Light & Proximity")
                onClicked: pageStackView.push(Qt.resolvedUrl("LightPage.qml"))
                highlighted: (lightsensor.isLogging || proximitysensor.isLogging)
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Pressure Sensor")
                onClicked: pageStackView.push(Qt.resolvedUrl("PressurePage.qml"))
                highlighted: pressuresensor.isLogging
            }
        }
    }
}
