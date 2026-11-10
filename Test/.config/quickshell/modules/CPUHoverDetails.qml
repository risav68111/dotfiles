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

    margins.left: parent.x + 11
    margins.top: parent.height + 6

    exclusionMode: ExclusionMode.Ignore

    HoverHandler {
        onHoveredChanged: popupOpen = hovered
    }

    // palette shared with the bar
    readonly property color bgColor: "#e61a1b26"      // AARRGGBB, ~90% opaque
    readonly property color trackColor: "#2a2b3a"
    readonly property color textColor: "#c6d0f5"
    readonly property color accent: "#7aa2f7"
    readonly property color warn: "#e0af68"
    readonly property color hot: "#f7768e"

    function usageColor(u) {
        return u >= 85 ? hot : (u >= 60 ? warn : accent);
    }

    Rectangle {
        id: rectInHoverWin
        anchors.fill: parent
        radius: 8
        color: cpuPopup.bgColor
        border.width: 1
        border.color: "#33c6d0f5"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 0

            Repeater {
                model: ResourceUsage.coreUsages.length

                Item {
                    id: row
                    required property int index
                    property real usage: ResourceUsage.coreUsages[index] ?? 0

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    RowLayout {
                        anchors.fill: parent
                        anchors.topMargin: 1
                        anchors.bottomMargin: 1
                        spacing: 6

                        Text {
                            Layout.preferredWidth: 62
                            Layout.alignment: Qt.AlignVCenter
                            text: (row.index + 1) + " : " + row.usage + " %"
                            color: cpuPopup.textColor
                            font.pixelSize: 11
                            font.bold: true
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 3
                            color: cpuPopup.trackColor

                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width * (row.usage / 100)
                                radius: 3
                                color: cpuPopup.usageColor(row.usage)

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 300
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                                Behavior on color {
                                    ColorAnimation { duration: 300 }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
