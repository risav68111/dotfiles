import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: wifi

    property bool connected: false
    property string ssid: ""
    property int signal: 0
    property bool isHovered: false

    readonly property var levelIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    readonly property string icon: !connected
        ? "󰤮"
        : levelIcons[Math.max(0, Math.min(Math.floor(signal / 25), 4))]

    readonly property real contentWidth: Math.ceil((label.implicitWidth + 24) / 8) * 8

    anchors.centerIn: parent
    height: parent.height - 4
    width: parent.width
    radius: 6
    color: "#1a1b26"
    opacity: isHovered ? 0.9 : 0.7

    Behavior on opacity {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }

    HoverHandler {
        onHoveredChanged: wifi.isHovered = hovered
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: wifi.icon + " " + (wifi.connected ? wifi.signal + "%" : "off")
        color: wifi.connected ? "#c6d0f5" : "#565f89"
        font {
            pixelSize: 12
            bold: true
            family: "JetBrainsMono Nerd Font"
        }
    }

    // prints the active network as "yes:SSID:SIGNAL", nothing if not connected
    Process {
        id: wifiProc
        command: ["sh", "-c",
            "nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | grep '^yes' | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim();
                if (!t) {
                    wifi.connected = false;
                    wifi.ssid = "";
                    wifi.signal = 0;
                    return;
                }
                const parts = t.split(":");
                wifi.connected = true;
                wifi.signal = parseInt(parts[parts.length - 1]) || 0;
                wifi.ssid = parts.slice(1, -1).join(":");
            }
        }
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: wifiProc.running = true
    }

    // click: open the network menu
    Process {
        id: openNm
        command: ["kitty", "-e", "nmtui"]
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: openNm.startDetached()
    }
}
