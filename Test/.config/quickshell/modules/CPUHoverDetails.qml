import Quickshell
import QtQuick
import QtQuick.Layouts
import "../service"

PanelWindow {
    id: cpuPopup
    required property bool popupOpen
    visible: popupOpen
    anchors.top: true
    anchors.right: false
    anchors.left: true
    anchors.bottom: false
    implicitWidth: parent.width
    implicitHeight: 160
    color: "transparent"

    // Component.onCompleted: Qt.callLater(() => {
    //   console.log("popup x:", x, "y:", y)
    //   console.log("popup width:", width, "height:", height)
    //   console.log("margins left:", margins.left, "top:", margins.top)
    //   console.log("screen:", screen ? screen.name : "none")
    //   console.log("screen width:", screen ? screen.width : 0, "height:", screen ? screen.height : 0)
    // })

    // Component.onCompleted: Qt.callLater(() => {
    //     console.log("xPos: ", parent.x);
    //     console.log("yPos: ", parent.height);
    // })
    margins.left: parent.x + 11
    margins.top: parent.height + 6

    exclusionMode: ExclusionMode.Ignore

    HoverHandler {
        onHoveredChanged: popupOpen = hovered
    }

    // property  color hoverBgColor: "#
    Rectangle {
        id: rectInHoverWin
        anchors.fill: parent
        radius: 8
        color: "yellow"
        function barsForProcessor(procUsages, i) {
            const icons = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"];
            let coreUsage = procUsages[i];
            return icons[Math.min(Math.floor(parseFloat(coreUsage) / 12.5), 7)] + " " + coreUsage + " %" + "  -  " + (i + 1);
        }

        gradient: Gradient {
            // orientation: Gradient.Horizontal

            GradientStop {
                position: 0.9
                color: "#555555"
            }

            GradientStop {
                position: 0.1
                color: "#666666"
            }
        }

        ColumnLayout {
            id: cpuUsagesfinal
            // Layout.alignment: Qt.AlignVCenter
            anchors.fill: parent
            // anchors.leftMargin: 8
            spacing: 0
            // ResourceUsage.coreUsages

            Repeater {
                model: ResourceUsage.coreUsages.length
                Rectangle {
                    required property int index
                    Layout.fillWidth: true
                    Layout.preferredHeight: cpuPopup.height / ResourceUsage.coreUsages.length
                    property int radiusOfSides: 10
                    color: "transparent"
                    // topLeftRadius: index==0 ? radiusOfSides: 0
                    // topRightRadius: index==0 ? radiusOfSides: 0
                    // bottomLeftRadius: index == ResourceUsage.coreUsages.length - 1 ? radiusOfSides : 0
                    // bottomRightRadius: index == ResourceUsage.coreUsages.length - 1 ? radiusOfSides : 0

                    RowLayout {
                        anchors.fill: parent
                        spacing: 3

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.preferredWidth: parent.width / 2.58
                            // height: parent.height
                            // width: parent.width / 2.58
                            Layout.leftMargin: 5
                            property int radiusOfSides: 10
                            topLeftRadius: parent.parent.index == 0 ? radiusOfSides : 0
                            color: "transparent"
                            // topRightRadius: index == 0 ? radiusOfSides : 0
                            bottomLeftRadius: parent.index == ResourceUsage.coreUsages.length - 1 ? radiusOfSides : 0
                            // bottomRightRadius: index == ResourceUsage.coreUsages.length - 1 ? radiusOfSides : 0
                            Text {
                                anchors.fill: parent
                                text: (parent.parent.parent.index + 1) + " : " + ResourceUsage.coreUsages[parent.parent.parent.index] + " %"
                                font.pixelSize: 11
                            }
                        }

                        Rectangle {
                            // Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            // width: (parent.width * ResourceUsage.coreUsages[parent.parent.index]) / 100
                            // color: "red"
                            radius: 3

                            gradient: Gradient {
                                // orientation: Gradient.Horizontal

                                GradientStop {
                                    position: 0.9
                                    color: "#555555"
                                }

                                GradientStop {
                                    position: 0.1
                                    color: "#666666"
                                }
                            }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width * (ResourceUsage.coreUsages[parent.parent.parent.index] / 100)
                                // color: "blue"
                                radius: 3

                                gradient: Gradient {
                                    // orientation: Gradient.Horizontal

                                    GradientStop {
                                        position: 0.9
                                        color: "#555555"
                                    }

                                    GradientStop {
                                        position: 0.1
                                        color: "#333333"
                                    }
                                }
                            }
                            Behavior on width {
                                NumberAnimation {
                                    duration: 300
                                    easing.type: InOutQuad
                                }
                            }
                        }

                        // anchors.centerIn:parent
                        // Layout.alignment: Qt.AlignVCenter
                        // width: parent.width
                        // height: 8
                        // color: "red"
                        // Text {
                        //     anchors.fill: parent
                        //     // Layout.alignment: Qt.AlignVCenter
                        //     // Layout.fillWidth: true
                        //     // Layout.fillHeight: true
                        //     // Component.onCompleted: Qt.callLater(() => {
                        //     //     console.log("ResourceUsage.coreUsages: ", ResourceUsage.coreUsages);
                        //     // })
                        //     // anchors.centerIn: parent
                        //     text: rectInHoverWin.barsForProcessor(ResourceUsage.coreUsages, parent.index)
                        //
                        //     //  + " " + cpuMonitor.cpuIcon + " " + cpuMonitor.cpuUsage + "%"
                        //     // text: " " + topProcs[0]
                        //     color: "#000000"
                        //     font.pixelSize: 13
                        // }
                    }
                }
            }
        }
    }
}
