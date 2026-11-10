import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

BarButton {
    id: bt

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool powered: adapter?.enabled ?? false
    readonly property var connectedDevices:
        (adapter?.devices?.values ?? []).filter(d => d.connected)
    readonly property int connectedCount: connectedDevices.length

    // 󰂲 off, 󰂯 on but idle, 󰂱 device connected
    label: !powered ? "󰂲"
         : connectedCount > 0 ? "󰂱" + (connectedCount > 1 ? " " + connectedCount : "")
         : "󰂯"
    fontSize: 15
    textColor: !powered ? "#565f89"
             : connectedCount > 0 ? "#7aa2f7"
             : "#c6d0f5"

    // left click: toggle Bluetooth power
    onClicked: if (adapter) adapter.enabled = !adapter.enabled

    // right click: open the manager
    Process {
        id: manager
        command: ["blueman-manager"]
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: manager.startDetached()
    }
}
