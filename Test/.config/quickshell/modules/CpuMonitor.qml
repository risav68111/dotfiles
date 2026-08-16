// CpuMonitor.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../service"
import QtQuick.Controls

// Rectangle {
//   height: 30
//   width: 30
// }
// anchors.verticalCenter: parent.verticalCenter
// height: parent.height
// width: parent.width
Rectangle {
    id: cpuMonitor
    anchors.centerIn: parent
    Layout.alignment: Qt.AlignVCenter
    height: parent.height - 4
    width: parent.width
    // radius: 5
    antialiasing: true
    color: "transparent"
    property bool isHovered: false

    Rectangle {
        id: grad1
        anchors.fill: parent
        // radius: parent.radius
        property int sideRadius: 6
        topLeftRadius: sideRadius
        bottomLeftRadius: sideRadius
        opacity: cpuMonitor.isHovered ? 0.9 : 0.7
        color: "#1a1b26"


        Behavior on opacity {
          NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
          }
        }
    }

    property var cpuUsage: ResourceUsage.cpuUsage ?? 0
    property var topProcs: ResourceUsage.topProcesses

    property string cpuIcon: icons[Math.min(Math.floor(parseFloat(cpuUsage) / 12.5), 7)]
    property var icons: ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

    function barsForEachProcessor(procUsages, icons) {
        var bars = "";
        for (let i = 0; i < procUsages.length; i++) {
            bars += icons[Math.min(Math.floor(parseFloat(procUsages[i]) / 12.5), 7)];
        }
        return bars;
    }

    Text {
        anchors.centerIn: parent
        text: parent.barsForEachProcessor(ResourceUsage.coreUsages, parent.icons) + " " + cpuMonitor.cpuUsage + "%"

        color: "#c6d0f5"
        font.pixelSize: 13
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Process {
        id: openBtop
        command: ["kitty", "-e", "btop"]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: openBtop.startDetached()
    }

    HoverHandler {
        onHoveredChanged: {
            cpuMonitor.isHovered = hovered
            root.popupOpen = hovered;
        }
    }

    CPUHoverDetails {
        popupOpen: cpuMonitor.isHovered
    }
}
