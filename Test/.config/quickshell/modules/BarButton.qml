import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: btn

    Layout.alignment: Qt.AlignVCenter
    property string label: ""
    property var command: []                  // e.g. ["kitty", "-e", "btop"]
    property color textColor: "#c6d0f5"
    property color baseColor: "#1a1b26"
    property color hoverColor: "#2a2b3a"
    property int fontSize: 14

    signal clicked()

    implicitWidth: Math.max(28, labelText.implicitWidth + 16)
    implicitHeight: 28
    radius: 8
    color: mouse.pressed ? "#3a3b4f" : (mouse.containsMouse ? hoverColor : baseColor)
    opacity: mouse.containsMouse ? 0.95 : 0.75
    scale: mouse.pressed ? 0.94 : 1.0

    Behavior on color { ColorAnimation { duration: 120 } }
    Behavior on opacity { NumberAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 80 } }

    Text {
        id: labelText
        anchors.centerIn: parent
        text: btn.label
        color: btn.textColor
        font.pixelSize: btn.fontSize
        font.family: "JetBrainsMono Nerd Font"
        font.bold: true
    }

    Process {
        id: proc
        command: btn.command
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            btn.clicked();
            if (btn.command.length > 0)
                proc.startDetached();
        }
    }
}
