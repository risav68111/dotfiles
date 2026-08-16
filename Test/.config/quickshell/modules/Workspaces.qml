import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: globalWorkspaceVar

    property int visibleCount: {
        let count = 0;
        for (let i = 1; i <= 10; i++) {
            let found = Hyprland.workspaces.values.find(w => w.id == i);
            let isActive = Hyprland.focusedWorkspace?.id === i;
            if (found !== undefined || isActive)
                count++;
        }
        return count;
    }

    property int activeCount: Hyprland.focusedWorkspace ? 1 : 0

    property real dynamicWidth: {
        let normal = (visibleCount - activeCount) * 22;
        let active = activeCount * 30;
        let spacing = (visibleCount - 1) * 1;
        let margins = 24;
        return normal + active + spacing + margins;
    }

    width: dynamicWidth

    Behavior on width {
        NumberAnimation {
            duration: 150
            easing.type: Easing.InOutQuad
        }
    }

    // property var gradientVar2: 0.1
    // property var gradientVar1: 0.9
    anchors.verticalCenter: parent.verticalCenter
    height: wsLayout.height
    color: "transparent"

    // function gradientChanger(val, toRest) {
    //     var variable = (val + 1) / 10;
    //     // variable = variable > 0.8 ? 0.8 : variable
    //     gradientVar1 = toRest ? 0.1 : variable;
    //     gradientVar2 = toRest ? 0.9 : 1.0 - variable;
    // }

    // Behavior on gradientVar1 {
    //     NumberAnimation {
    //         duration: 3000
    //         easing.type: Easing.InOutQuad
    //     }
    // }
    //
    // Behavior on gradientVar2 {
    //     NumberAnimation {
    //         duration: 3000
    //         easing.type: Easing.InOutQuad
    //     }
    // }

    Rectangle {

        radius: leftSideBarRect.radius
        // topRightRadius: 6
        // bottomRightRadius: 6
        // topLeftRadius: leftSideBarRect.radius
        // bottomLeftRadius: leftSideBarRect.radius
        anchors.fill: parent

        antialiasing: true

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop {
                position: 1.0
                color: "#666666"
            }

            GradientStop {
                position: 0.1
                color: "#221111"
            }
        }
        // gradient: Gradient {
        //     orientation: Gradient.Horizontal
        //
        //     GradientStop {
        //         position: globalWorkspaceVar.gradientVar1
        //         color: "#666666"
        //     }
        //
        //     GradientStop {
        //         position: globalWorkspaceVar.gradientVar2
        //         color: "#221111"
        //     }
        // }
    }

    Rectangle {
        id: workspaceMainRect
        width: parent.width - 4
        height: parent.height - 4
        color: "#666666"
        radius: leftSideBarRect.radius
        // topRightRadius: 6
        // bottomRightRadius: 6
        // topLeftRadius: (leftSideBarRect.radius )
        // bottomLeftRadius: (leftSideBarRect.radius )

        anchors {
            centerIn: parent
        }

        antialiasing: true

        gradient: Gradient {
            // orientation: Gradient.Horizontal

            GradientStop {
                position: 0.1
                color: "#666666"
            }

            GradientStop {
                position: 1.0
                color: "#221111"
            }
        }
        // gradient: Gradient {
        //     orientation: Gradient.Horizontal
        //
        //     GradientStop {
        //         position: globalWorkspaceVar.gradientVar2
        //         color: "#333333"
        //     }
        //
        //     GradientStop {
        //         position: globalWorkspaceVar.gradientVar1
        //         color: "#111111"
        //     }
        // }

        // bottomRightRadius: leftSideBarRect.radius/2
        RowLayout {
            id: workspaces
            // Layout.alignment: Qt.AlignVCenter
            anchors.fill: parent
            anchors.leftMargin: 8
            spacing: 0
            Repeater {
                model: 10
                Rectangle {
                    id: befRep
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: shouldShow ? 1 : 0
                    required property int index
                    property int wsIndex: index + 1
                    property var ws: Hyprland.workspaces.values.find(w => w.id == wsIndex)
                    property bool isActive: Hyprland.focusedWorkspace?.id === wsIndex
                    property bool isHovered: false
                    property bool shouldShow: {
                        let found = Hyprland.workspaces.values.find(w => w.id == wsIndex);
                        return found !== undefined || isActive;
                    }

                    Layout.preferredWidth: shouldShow ? (isActive ? 35 : 22) : 0
                    height: 16
                    radius: 16
                    clip: true
                    visible: true
                    opacity: shouldShow ? 1.0 : 0.0
                    color: isHovered ? "#1f3b3d" : "transparent"
                    // border {
                    //   width: 1
                    //   color: "yellow"
                    // }
                    gradient: Gradient.SleeplessNight

                    Behavior on Layout.preferredWidth {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.InOutQuad
                        }
                    }

                    // Text {
                    //     anchors.centerIn: parent
                    //     text: (befRep.index + 1).toString(16).toUpperCase()
                    //     color: befRep.isHovered ? "#ffffff" : (befRep.isActive ? "#0db947" : (befRep.ws ? "#7aa2f7" : "#444b6a"))
                    //     font {
                    //         pixelSize: 15
                    //         bold: true
                    //     }
                    // }

                    HoverHandler {
                        onHoveredChanged: {
                            parent.isHovered = hovered;
                            // globalWorkspaceVar.gradientChanger(parent.index, !hovered);
                        }
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
}
