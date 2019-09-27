import QtQuick 2.9
import QtQuick.Controls 2.0

import "../Theme.js" as Theme

Dialog {
    id: dialog
    header: Label { text: qsTr("Accelerometer") }

    onAccepted: {
        settings.loggingPath = loggingPath.text;
        settings.preventDisplayBlanking = preventDisplayBlanking.checked;
    }


    Column {
        id: column

        width: dialog.width
        spacing: Theme.paddingLarge

        Button {
            text: qsTr("Save")
            onClicked: dialog.accept();
        }

        Label {
            text: qsTr("Logging")
        }

        TextField {
            id: loggingPath
            width: parent.width
            inputMethodHints: Qt.ImhNoAutoUppercase
            text: settings.loggingPath
          //  label: qsTr("Path for sensor logs")
        }

        Switch {
            id: preventDisplayBlanking
            text: qsTr("Prevent display blanking")
            //description: qsTr("Prevents display blanking on sensor plotting pages")
            checked: settings.preventDisplayBlanking
            enabled: !settings.isHarbourVersion
        }
    }
}
