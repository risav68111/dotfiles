import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: battery

    property int pct: 0
    property string status: "Unknown"      // Charging, Discharging, Full, Not charging
    property bool present: false
    property bool isHovered: false

    readonly property bool charging: status === "Charging" || status === "Full"
    readonly property bool low: pct <= 20 && !charging

    readonly property var levelIcons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    readonly property string icon: charging
        ? "󰂄"
        : levelIcons[Math.max(0, Math.min(Math.floor(pct / 10), 9))]

    readonly property real contentWidth: Math.ceil((label.implicitWidth + 24) / 8) * 8

    visible: present
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
        onHoveredChanged: battery.isHovered = hovered
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: battery.icon + " " + battery.pct + "%"
        color: battery.low ? "#f7768e" : (battery.charging ? "#9ece6a" : "#c6d0f5")
        font {
            pixelSize: 12
            bold: true
            family: "JetBrainsMono Nerd Font"
        }
    }

    // prints e.g. "88 Charging"; prints nothing on machines without a battery
    Process {
        id: batProc
        command: ["sh", "-c",
            "b=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1); " +
            "[ -n \"$b\" ] && echo \"$(cat $b/capacity) $(cat $b/status)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim();
                if (!t) {
                    battery.present = false;
                    return;
                }
                const i = t.indexOf(" ");
                battery.pct = parseInt(t.substring(0, i)) || 0;
                battery.status = t.substring(i + 1);
                battery.present = true;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: batProc.running = true
    }
}
