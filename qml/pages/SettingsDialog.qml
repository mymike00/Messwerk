import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UITK
// import Ubuntu.Components.Popups 1.3 as POPUPS

import "../Theme.js" as Theme

Dialog {
    id: dialog
    modal: true
    title: i18n.tr("Logging")
    function open() {
        dialog.open();
    }

    function accept () {
        settings.loggingPath = loggingPath.text;
        settings.preventDisplayBlanking = preventDisplayBlanking.checked;
    }


    Column {
        id: column

        width: dialog.width
        spacing: Theme.paddingLarge

        Label {
            text: i18n.tr("Path for sensor logs:\n%1").arg(settings.loggingPath)
        }

        // TextField {
        //     inputMethodHints: Qt.ImhNoAutoUppercase
        //     text: settings.loggingPath
        // }
        // ComboBox {
        //     id: loggingPath
        //     width: parent.width
        //     model: ListModel {
        //         id: model
        //         ListElement { text: "config" }
        //         ListElement { text: "cache" }
        //         ListElement { text: "appData" }
        //     }
        //     onActivated: {
        //
        //     }
        // }
        // UITK.ListItem {
        //     width: parent.width
        //     UITK.ListItemLayout {
        //         title.text: i18n.tr("Prevent display blanking")
        //         subtitle.text: i18n.tr("Prevents display blanking on sensor plotting pages")
        //         Switch {
        //             id: preventDisplayBlanking
        //             // text: i18n.tr("Prevent display blanking")
        //             // description: i18n.tr("Prevents display blanking on sensor plotting pages")
        //             checked: settings.preventDisplayBlanking
        //             enabled: !settings.isHarbourVersion
        //         }
        //     }
        // }
        // Switch {
        //     id: preventDisplayBlanking
        //     text: i18n.tr("Prevent display blanking")
        //     // description: i18n.tr("Prevents display blanking on sensor plotting pages")
        //     checked: settings.preventDisplayBlanking
        //     enabled: !settings.isHarbourVersion
        // }
        // Row {
        //     width: parent.width
        //     spacing: Theme.paddingLarge
        //     Button {
        //         width: (parent.width - Theme.paddingLarge) / 2
        //         text: i18n.tr("Cancel")
        //         onClicked: dialog.reject();
        //     }
        //     Button {
        //         width: (parent.width - Theme.paddingLarge) / 2
        //         text: i18n.tr("Save")
        //         onClicked: dialog.accept();
        //     }
        // }
        standardButtons: Dialog.Save | Dialog.Cancel
    }
}
