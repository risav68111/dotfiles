import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Rectangle {
    anchors.fill: parent
    height: 100
    color: parent.color
    // opacity: 0
    // ColumnLayout {
    //     // Layout.alignment: Qt.AlignHCenter
    //     id: workspaces
    //     anchors.fill: parent
    //     anchors.margins: 0
    //     spacing: 0
    //     Repeater {
    //         model: 10
    //         Rectangle {
    //             Layout.alignment: Qt.AlignHCenter
    //             required property int index
    //             property int wsIndex: index + 1
    //             property var ws: Hyprland.workspaces.values.find(w => w.id == wsIndex)
    //             property bool isActive: Hyprland.focusedWorkspace?.id === wsIndex
    //             property bool isHovered: false
    //
    //             width: 28
    //             height: 28
    //             radius: 6
    //             color: isHovered ? "#2a2b3d" : "transparent"
    //
    //             Text {
    //                 anchors.centerIn: parent
    //                 text: parent.isActive ? "" : ""
    //                 color: parent.isHovered ? "#ffffff" : (parent.isActive ? "#0db947" : (parent.ws ? "#7aa2f7" : "#444b6a"))
    //                 font {
    //                     pixelSize: 30
    //                     bold: true
    //                 }
    //             }
    //
    //             HoverHandler {
    //                 onHoveredChanged: parent.isHovered = hovered
    //             }
    //
    //             MouseArea {
    //                 anchors.fill: parent
    //                 onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + parent.wsIndex + "})")
    //             }
    //         }
    //     }
    //     Item {
    //         Layout.fillHeight: true
    //     }
    // }

    // Repeater {
    //     model: 10
    //     Rectangle {
    //         Layout.alignment: Qt.AlignVCenter
    //         required property int index
    //         property int wsIndex: index + 1
    //         property var ws: Hyprland.workspaces.values.find(w => w.id == wsIndex)
    //         property bool isActive: Hyprland.focusedWorkspace?.id === wsIndex
    //         property bool hasWindows: Hyprland.windows.values.some(w => w.workspace?.id == wsIndex)
    //         property bool isHovered: false
    //
    //         // show if focused (even when empty) or has windows, hide if truly empty
    //         visible: isActive || hasWindows
    //
    //         width: 28
    //         height: 28
    //         radius: 6
    //         color: isHovered ? "#2a2b3d" : "transparent"
    //
    //         Text {
    //             anchors.centerIn: parent
    //             text: parent.wsIndex  // ← shows workspace number
    //             color: parent.isHovered ? "#ffffff" : parent.isActive ? "#0db947"   // green = focused
    //             : parent.hasWindows ? "#7aa2f7"  // blue = has windows
    //             : "#444b6a"                       // dim = empty but open
    //             font {
    //                 pixelSize: 12
    //                 bold: true
    //             }
    //         }
    //
    //         HoverHandler {
    //             onHoveredChanged: parent.isHovered = hovered
    //         }
    //
    //         MouseArea {
    //             anchors.fill: parent
    //             onClicked: Hyprland.dispatch("workspace " + parent.wsIndex)
    //         }
    //     }
    // }

    RowLayout {
        // Layout.alignment: Qt.AlignHCenter
        id: workspaces
        anchors.fill: parent
        // anchors.margins: 0
        spacing: 0
        Repeater {
            model: 10
            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                // Layout.alignment: Qt.AlignHCenter
                required property int index
                property int wsIndex: index + 1
                property var ws: Hyprland.workspaces.values.find(w => w.id == wsIndex)
                property bool isActive: Hyprland.focusedWorkspace?.id === wsIndex
                property bool isHovered: false

                width: 20
                height: 28
                radius: 6
                color: isHovered ? "#2a2b3d" : "transparent"

                Text {
                    anchors.centerIn: parent
                    // text: parent.isActive ? "" : ""
                    text:  parent.index + 1
                    color: parent.isHovered ? "#ffffff" : (parent.isActive ? "#0db947" : (parent.ws ? "#7aa2f7" : "#444b6a"))
                    font {
                        pixelSize: 15
                        bold: true
                    }
                }

                HoverHandler {
                    onHoveredChanged: parent.isHovered = hovered
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + parent.wsIndex + "})")
                }
            }
        }
        Item {
            // Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
