import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../service"

Rectangle {
    id: ramMonitor
    anchors.centerIn: parent
    Layout.alignment: Qt.AlignVCenter
    height: parent.height - 4
    width: parent.width
    color: "#1a1b26"
    opacity: isHovered ? 0.9 : 0.7
    // radius: 5
    property int radiusSide: 5
    topRightRadius: radiusSide
    bottomRightRadius: radiusSide

    property bool isHovered: false

        Behavior on opacity {
            NumberAnimation {
                duration: 300
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
        color: "#c6d0f5"
        text: ResourceUsage.memoryUsage + "/" + ResourceUsage.totalMemory + "G"
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
