import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Io
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
    BrightnessOSD {}
    // NotificationPopups {}

    PanelWindow {
        id: shellRootId
        // screen: Quickshell.screens.find(s => s.name === "eDP-1")
        screen: Quickshell.screens.find(s => s.name === "HDMI-A-2")
        anchors.top: true
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
            radius: 0

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

                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1      // same as the right zone = equal share
                    Layout.fillHeight: true
                    clip: true

                    RowLayout {
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
                            Layout.preferredWidth: cpuMon.contentWidth
                            Layout.fillHeight: true
                            Layout.minimumHeight: 15
                            Layout.preferredHeight: 28
                            Layout.leftMargin: 3

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            CpuMonitor {
                                id: cpuMon
                            }
                        }

                        Rectangle {
                            id: tempRow
                            Layout.alignment: Qt.AlignVCenter
                            color: 'transparent'
                            Layout.preferredWidth: tempMon.contentWidth
                            Layout.fillHeight: true
                            Layout.minimumHeight: 15
                            Layout.preferredHeight: 28
                            Layout.leftMargin: 0

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            CPUTemp {
                                id: tempMon
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            color: 'transparent'
                            Layout.preferredWidth: ramMon.contentWidth
                            Layout.fillHeight: true
                            Layout.minimumHeight: 15
                            Layout.preferredHeight: 28
                            Layout.leftMargin: 0

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            RamUsage {
                                id: ramMon
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            color: 'transparent'

                            // fixed slot: height is fixed, width follows the icons, capped at 570
                            Layout.preferredWidth: activeApps.implicitWidth
                            Layout.maximumWidth: 570
                            Layout.preferredHeight: 28
                            Layout.fillHeight: true
                            Layout.minimumHeight: 15
                            Layout.leftMargin: 4

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            ActiveApps {
                                id: activeApps
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true
                    clip: true
                    DateTime {
                        anchors.centerIn: parent
                        // Layout.alignment: Qt.AlignHCenter
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    Layout.fillHeight: true
                    clip: true

                    RowLayout {
                        anchors.fill: parent
                        spacing: 4
                        Item {
                            Layout.fillWidth: true
                        }   // pushes future modules to the right edge
                        // ...network, volume, battery, etc. go here later...

                        Brightness {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Volume {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        BluetoothButton {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        WarpButton {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            color: 'transparent'
                            Layout.preferredWidth: wifiMon.contentWidth
                            Layout.preferredHeight: 28
                            Layout.leftMargin: 4

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Wifi {
                                id: wifiMon
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            color: 'transparent'
                            Layout.preferredWidth: batMon.contentWidth
                            Layout.preferredHeight: 28
                            Layout.leftMargin: 4
                            visible: true
                            // visible: batMon.visible

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Battery {
                                id: batMon
                            }
                        }

                        BarButton {
                            Layout.alignment: Qt.AlignVCenter
                            label: "󰂜"
                            fontSize: 15
                            command: ["swaync-client", "-t", "-sw"]
                        }

                        BarButton {
                            Layout.alignment: Qt.AlignVCenter
                            label: "󰐥"
                            command: ["wlogout"]
                        }
                    }
                }
            }
        }
    }
}
