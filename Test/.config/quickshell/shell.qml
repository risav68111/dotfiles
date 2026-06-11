import Quickshell
import QtQuick
import Quickshell.Wayland
import "modules"

ShellRoot {
    id: root

    property var sidebarThickness: 32
    PanelWindow {
        id: leftSideBar
        anchors.top: true
        anchors.left: true
        anchors.right: true
        exclusiveZone: root.sidebarThickness
        implicitHeight: root.sidebarThickness
        WlrLayershell.namespace: "bar" 
        margins {
            top: 4
            left: 10
            right: 10
            bottom: 2
        }
        color: "transparent"

        Rectangle {
            id: leftSideBarRect
            anchors {
                fill: parent
            }
            color: "#1a1b26"
            // height: parent.height
            // width: parent.width
            radius: 30

            Workspaces {}
            DateTime {}
        }
    }
}
