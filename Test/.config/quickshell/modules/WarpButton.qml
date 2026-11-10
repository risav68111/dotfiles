import Quickshell.Io
import QtQuick

BarButton {
    id: warp

    property string status: ""      // whatever warp_status.sh prints (the glyph)

    // show the script's glyph; fall back to a placeholder until the first poll
    label: status !== "" ? status : "?"
    fontSize: 15

    // left click: connect
    command: ["sh", "-c", "~/.config/scripts/warp_connect.sh"]

    // status poll, every 3s like your Waybar interval
    Process {
        id: statusProc
        command: ["sh", "-c", "~/.config/scripts/warp_status.sh"]
        stdout: StdioCollector {
            onStreamFinished: warp.status = text.trim()
        }
    }
    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusProc.running = true
    }

    // right click: disconnect
    Process {
        id: disconnectProc
        command: ["sh", "-c", "~/.config/scripts/warp_disconnect.sh"]
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: disconnectProc.startDetached()
    }
}
