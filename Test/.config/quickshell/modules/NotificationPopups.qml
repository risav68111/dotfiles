import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "../service"

PanelWindow {
    anchors.top: true
    anchors.right: true
    margins.top: 44
    margins.right: 10
    exclusiveZone: 0
    implicitWidth: 340
    implicitHeight: col.implicitHeight + 1
    color: "transparent"
    visible: col.implicitHeight > 0 && !Notifications.dnd

    ColumnLayout {
        id: col
        width: parent.width
        spacing: 8

        Repeater {
            model: Notifications.server.trackedNotifications

            Rectangle {
                id: card
                required property var modelData
                property bool shown: true

                visible: shown
                Layout.fillWidth: true
                Layout.preferredHeight: shown ? body.implicitHeight + 20 : 0
                radius: 10
                color: "#e61a1b26"
                border.width: 1
                border.color: modelData.urgency === NotificationUrgency.Critical ? "#f7768e" : "#33c6d0f5"

                Timer {
                    interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout * 1000 : 5000
                    running: card.modelData.urgency !== NotificationUrgency.Critical
                    onTriggered: card.shown = false   // hide popup, stays in history
                }

                ColumnLayout {
                    id: body
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 2
                    Text {
                        text: card.modelData.appName + " · " + card.modelData.summary
                        color: "#7aa2f7"
                        font { pixelSize: 12; bold: true }
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: card.modelData.body
                        color: "#c6d0f5"
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: card.modelData.dismiss()
                }
            }
        }
    }
}
