import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UITK

import "../Theme.js" as Theme

Page {
    id: page
    header: UITK.PageHeader {
        id: pageH
        title: i18n.tr("Info")
        navigationActions: UITK.Action {
            iconName: "back"
            text: i18n.tr('Back')
            onTriggered: page.StackView.view.pop();
        }
    }

    Flickable {
        anchors {
            fill: parent
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Created by bytewerk™ Software Inc.")
                color: Theme.highlightColor
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Send beer, pizza and Club Mate to")
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "http://www.bytewerk.org"
                onClicked: Qt.openUrlExternally("http://www.bytewerk.org")
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("source code")
                onClicked: Qt.openUrlExternally("https://github.com/Bytewerk/Messwerk")
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Credits")
                font.capitalization: Font.SmallCaps
                font.weight: Font.DemiBold
                font.pixelSize: units.gu(3)
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Coding: ") + "cfr34k"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Quality assurance: ") + "sqozz"
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Art & Design: ") + "sqozz, cfr34k"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Translations: ") + "sqozz, cfr34k"
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    text: i18n.tr("Port to Ubuntu Touch: ")
                    font.capitalization: Font.SmallCaps
                    font.weight: Font.DemiBold
                }
                Label {
                    text: "<a href=\"https://github.com/mymike00/\">Michele</a>"
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }
}
