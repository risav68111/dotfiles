import Quickshell
import QtQuick
import QtQuick.Layouts
import "../service"
import Quickshell.Io

Rectangle {
    id: cpuTempMonitor
    anchors.centerIn: parent
    Layout.alignment: Qt.AlignVCenter
    height: parent.height - 4
    width: parent.width 
    color: "#1a1b26"
    property bool isHovered: false
    opacity: isHovered ? 0.9 : 0.7

    Behavior on opacity {
      NumberAnimation {
        duration: 350
        easing.type: Easing.InOutQuad
      }
    }

    HoverHandler {
        onHoveredChanged: {
            parent.isHovered = hovered
        }
    }

    Text {
        anchors.centerIn: parent
        text:  ResourceUsage.cpuTemp + "℃  | " + ResourceUsage.gpuTemp + "℃ "
        color: "#c6d0f5"
        font {
            pixelSize: 12
            bold: true 
        }
    }

    Process {
      id: openBtop
      command: ["kitty", "-e", "btop"]
    }

    MouseArea {
        anchors.fill: parent
        onClicked: openBtop.startDetached()
    }
}
