import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Hyprland
import "modules"
import "component"

ShellRoot {
    id: root
    property bool popupOpen: false
    Component.onCompleted: {
        Quickshell.iconTheme = "breeze-dark";
    }

    property var sidebarThickness: 32
    VolumeOSD {}
    BrightnessOSD{}

    PanelWindow {
        id: leftSideBar
        // screen: Quickshell.screens.find(s => s.name === "eDP-1")
        screen: Quickshell.screens.find(s => s.name === "HDMI-A-2")
        anchors.top:true 
        anchors.bottom: false 
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
            height: parent.height
            width: parent.width
            color: "transparent"
            radius: 30

            // gradient: Gradient {
            //     // orientation: Gradient.Horizontal
            //     GradientStop {
            //         position: 0.0
            //         color: "#4a1b26"
            //     }
            //     GradientStop {
            //         position: 0.7
            //         color: "#1a1b26"
            //     }
            //     GradientStop {
            //         position: 1.0
            //         color: "#4a1b26"
            //     }
            // }

            RowLayout {
                id: wsLayout
                // required property int index
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    color: 'transparent'
                    // Layout.fillWidth: true
                    Layout.preferredWidth: workspacesItem.dynamicWidth

                    Layout.fillHeight: true
                    Layout.minimumHeight: 15
                    Layout.preferredHeight: 28

                    Workspaces {
                        id: workspacesItem
                    }

                    Behavior on Layout.preferredWidth {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Rectangle {
                    id: secRect
                    Layout.alignment: Qt.AlignVCenter
                    color: 'transparent'
                    Layout.fillWidth: true
                    // Layout.minimumWidth: 30
                    Layout.preferredWidth: 120
                    Layout.maximumWidth: 120

                    Layout.fillHeight: true
                    Layout.minimumHeight: 15
                    Layout.preferredHeight: 28
                    Layout.leftMargin: 3

                    CpuMonitor {}
                    // CPUHoverDetails {
                    //     popupOpen: root.popupOpen
                    //     // anchors.left: tempRow.width
                    //     // anchors.top: parent.height
                    //     // Component.onCompleted: Qt.callLater (() => {
                    //     //   console.log("x: ", parent.x);
                    //     //   console.log("y: ", tempRow.height);
                    //     // })
                    // }
                }

                Rectangle {
                    id: tempRow
                    Layout.alignment: Qt.AlignVCenter
                    color: 'transparent'
                    Layout.fillWidth: true
                    // Layout.minimumWidth: 30
                    Layout.preferredWidth: 80
                    Layout.maximumWidth: 80

                    Layout.fillHeight: true
                    Layout.minimumHeight: 15
                    Layout.preferredHeight: 28
                    CPUTemp {}
                }

                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    color: 'transparent'
                    Layout.fillWidth: true
                    Layout.minimumWidth: 70
                    Layout.preferredWidth: 70
                    Layout.maximumWidth: 70

                    Layout.fillHeight: true
                    Layout.minimumHeight: 15
                    Layout.preferredHeight: 28

                    RamUsage {}
                }

                Rectangle {
                    color: 'transparent'
                    Layout.fillWidth: true
                    Layout.minimumWidth: 100
                    Layout.preferredWidth: 200
                    Layout.fillHeight: true
                    Layout.minimumHeight: 15
                    Layout.preferredHeight: 28
                    Text {
                        anchors.centerIn: parent
                        text: parent.width + 'x' + parent.height
                    }

                    // WorkspaceWithApps {}
                }

                DateTime {
                    anchors.centerIn: parent
                    // Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
